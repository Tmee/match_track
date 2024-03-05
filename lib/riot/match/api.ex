defmodule MatchTrack.Riot.Match.Api do
  alias MatchTrack.Riot.Match.Base, as: Riot

  def get_match_details(match_id) do
    Riot.get("/lol/match/v5/matches/#{match_id}")
  end

  def get_matches_by_puuid(puuid) do
    Riot.get("/lol/match/v5/matches/by-puuid/#{puuid}/ids")
  end
end
