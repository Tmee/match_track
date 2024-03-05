defmodule MatchTrack.Summoner.Server do
  use GenServer

  @timeout 1000 * 60 * 60
  @match_check_delay 2 * 1000

  alias MatchTrack.Riot.Match.Api, as: Riot
  alias MatchTrack.SummonerManager.Api, as: SummonerManager

  defstruct puuid: nil, name: nil, previous_matches: []

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :temporary
    }
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(opts[:puuid], opts[:name]))
  end

  def init(opts) do
    # 1 hour in milliseconds
    Process.send_after(self(), :terminate, 60 * 60 * 1000)

    send(self(), :deferred_init)
    {:ok, opts}
  end

  def handle_info(:deferred_init, opts) do
    init_state = MatchTrack.Summoner.get_initial_state(opts[:puuid], opts[:name])

    {:noreply, init_state, @timeout}
  end

  def handle_info(:timeout, state), do: {:stop, {:shutdown, :timeout}, state}

  def handle_info(:terminate, state) do
    exit(:normal)
    {:noreply, state}
  end

  def handle_info(
        {:check_matches},
        %{puuid: puuid, name: name, previous_matches: prev_matches} = state
      ) do
    new_matches = Riot.get_matches_by_puuid(puuid)

    (new_matches -- prev_matches)
    |> Enum.each(fn match_id ->
      IO.puts(:stdio, "Summoner #{name} completed match #{match_id}")
    end)

    schedule_next_match_check()
    {:noreply, %{state | previous_matches: new_matches}}
  end

  def handle_cast(:restart_timeout, state), do: {:noreply, state, @timeout}

  def handle_cast({:check_matches}, state) do
    Process.send_after(self(), {:check_matches}, @match_check_delay)
    {:noreply, state}
  end

  def handle_call({:recent_participants}, _from, %{previous_matches: []} = state) do
    schedule_next_match_check()

    {:reply, {:ok, []}, state, @timeout}
  end

  def handle_call({:recent_participants}, _from, %{previous_matches: prev_matches} = state) do
    # for each match, get participant details
    # pull out puuid and summoner name from participant list
    participants =
      prev_matches
      |> Enum.take(5)
      |> Enum.flat_map(fn match_id ->
        Riot.get_match_details(match_id)
        |> Map.get(:info)
        |> Map.get(:participants)
        |> Enum.map(fn participant ->
          {participant.puuid, participant.summonerName}
        end)
      end)
      |> Enum.into(%{})

    # for each participant, spawn new process
    Enum.each(participants, fn {puuid, name} ->
      monitor_new_summoner(puuid, name)
    end)

    schedule_next_match_check()
    {:reply, {:ok, Map.values(participants)}, state, @timeout}
  end

  defp monitor_new_summoner(puuid, name) do
    {:ok, pid} = SummonerManager.get_summoner_pid(puuid, name)

    GenServer.cast(pid, {:check_matches})
  end

  defp schedule_next_match_check() do
    # 1 minute in milliseconds
    Process.send_after(self(), {:check_matches}, @match_check_delay)
  end

  defp via_tuple(puuid, name) do
    {:via, Registry, {Registry.MatchTrack.Summoner, "Summoner_#{puuid}:#{name}"}}
  end
end
