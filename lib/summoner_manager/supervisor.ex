defmodule MatchTrack.SummonerManager.Supervisor do
  use DynamicSupervisor

  @registry_name :"Elixir.MatchTrack.SummonerManager"

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: @registry_name)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
