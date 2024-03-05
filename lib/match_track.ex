defmodule MatchTrack do
  alias MatchTrack.Summoner.Api, as: Summoner
  alias MatchTrack.SummonerManager.Api, as: Manager

  def recent_participants(summoner_name) do
    with {:ok, pid} <- Manager.get_summoner_pid_by_name(summoner_name),
         {:ok, participants} <- Summoner.recent_participants(pid) do
      participants
    else
      err -> err
    end
  end
end
