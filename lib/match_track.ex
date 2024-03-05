defmodule MatchTrack do
  alias MatchTrack.Summoner.Api, as: Summoner
  alias MatchTrack.SummonerManager.Api, as: Manager

  def recent_participants(summoner_name), do: recent_participants(summoner_name, "")

  def recent_participants(summoner_name, _region) do
    Manager.get_summoner_pid_by_name(summoner_name)
    |> case do
      {:ok, pid} ->
        Summoner.recent_participants(pid)

      err ->
        err
    end
  end
end
