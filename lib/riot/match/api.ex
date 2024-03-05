defmodule MatchTrack.Riot.Match.Api do
  alias MatchTrack.Riot.Match.Base, as: Riot

  def get_match_details(match_id) do
    Riot.get("/lol/match/v5/matches/#{match_id}")
    |> case do
      {:ok, %{status_code: 429}} ->
        :timer.sleep(2000)
        get_match_details(match_id)

      {:ok, %{body: body}} ->
        body
    end
  end

  def get_matches_by_puuid(puuid) do
    Riot.get("/lol/match/v5/matches/by-puuid/#{puuid}/ids")
    |> case do
      {:ok, %{status_code: 429}} ->
        :timer.sleep(2000)
        get_matches_by_puuid(puuid)

      {:ok, %{body: body}} ->
        body
    end
  end
end
