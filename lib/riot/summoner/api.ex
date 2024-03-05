defmodule MatchTrack.Riot.Summoner.Api do
  alias MatchTrack.Riot.Summoner.Base, as: Riot

  def get_summoner_by_name(name) do
    Riot.get("/lol/summoner/v4/summoners/by-name/#{name}")
  end
end
