defmodule Game.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.ViaGame},
      Game.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Game.Application]
    Supervisor.start_link(children, opts)
  end
end
