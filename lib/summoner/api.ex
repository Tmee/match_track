defmodule MatchTrack.Summoner.Api do
  def recent_participants(pid) do
    GenServer.call(pid, {:recent_participants})
  end
end
