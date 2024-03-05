defmodule MatchTrack.SummonerManager do
  alias MatchTrack.Riot.Summoner.Api, as: Riot

  @summoner_mgr_supervisor :"Elixir.MatchTrack.SummonerManager"

  def get_summoner_pid(puuid, name) do
    child =
      DynamicSupervisor.start_child(
        @summoner_mgr_supervisor,
        {MatchTrack.Summoner.Server, [puuid: puuid, name: name]}
      )

    case child do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> restart_child_timeout(pid)
    end
  end

  def get_summoner_pid_by_name(name) do
    Riot.get_summoner_by_name(name)
    |> case do
      {:ok, %{body: body, status_code: 200}} ->
        get_summoner_pid(body.puuid, name)

      {:ok, %{body: body}} ->
        {:error, body}

      err ->
        err
    end
  end

  defp restart_child_timeout(pid) do
    GenServer.cast(pid, :restart_timeout)
    {:ok, pid}
  end
end
