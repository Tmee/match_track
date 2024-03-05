defmodule MatchTrack.Riot.Summoner.Api do
  alias MatchTrack.Riot.Summoner.Base, as: Riot

  def get_summoner_puuid_by_name(name) do
    Riot.get("/lol/summoner/v4/summoners/by-name/#{name}")
    |> case do
      {:ok, %{status: %{status_code: 429}}} ->
        :timer.sleep(2000)
        get_summoner_puuid_by_name(name)

      {:ok, %{body: body}} ->
        body.puuid
    end
  end
end
