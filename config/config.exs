import Config

config :match_track,
  riot_token: System.get_env("RIOT_TOKEN"),
  riot_base_url: "api.riotgames.com",
  riot_summoner_region: "na1",
  riot_match_region: "americas"
