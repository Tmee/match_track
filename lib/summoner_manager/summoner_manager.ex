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
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

  def get_summoner_pid_by_name(name) do
    Riot.get_summoner_puuid_by_name(name)
    |> get_summoner_pid(name)
  end
end
