defmodule Game.Supervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_game(id) do
    spec = %{
      id: Game.Server,
      start: {Game.Server, :start_link, [id]},
      restart: :transient,
      shutdown: 10_000
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
