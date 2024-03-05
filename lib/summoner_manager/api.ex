defmodule MatchTrack.SummonerManager.Api do
  alias MatchTrack.SummonerManager

  def get_summoner_pid(puuid, name) do
    SummonerManager.get_summoner_pid(puuid, name)
  end

  def get_summoner_pid_by_name(name) do
    SummonerManager.get_summoner_pid_by_name(name)
  end
end
