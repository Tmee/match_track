defmodule MatchTrack.Riot.Api do
  alias MatchTrack.Riot.Base, as: Riot

  def get_summoner_by_name(name) do
    Riot.get("/lol/summoner/v4/summoners/by-name/#{name}")
  end

  def get_match_details(match_id) do
    Riot.get("/lol/match/v5/matches/#{match_id}")
  end

  def get_matches_by_puuid(puuid) do
    Riot.get("/lol/match/v5/matches/by-puuid/#{puuid}/ids")
  end
end
