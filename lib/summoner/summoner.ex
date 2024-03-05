defmodule MatchTrack.Summoner do
  alias MatchTrack.Riot.Match.Api, as: Riot
  alias MatchTrack.Summoner.Server

  def get_initial_state(puuid, name) do
    matches = Riot.get_matches_by_puuid(puuid)

    %Server{
      puuid: puuid,
      name: name,
      previous_matches: matches
    }
  end
end
