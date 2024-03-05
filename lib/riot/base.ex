defmodule MatchTrack.Riot.Base do
  use HTTPoison.Base

  # region needs to be an arg on the function and passed into the first call, not at config level
  def process_request_url(path) do
    base_url = Application.fetch_env!(:match_track, :riot_base_url)
    region = Application.fetch_env!(:match_track, :riot_region)

    "https://#{region}.#{base_url}#{path}"
  end

  def process_request_headers(_headers) do
    [
      "X-Riot-Token": Application.fetch_env!(:match_track, :riot_token),
      Accept: "*/*"
    ]
  end

  def process_response_body(body) do
    body
    |> Jason.decode(%{keys: :atoms})
    |> elem(1)
    |> case do
      %{errors: [error]} -> {:error, error}
      body -> body
    end
  end
end
