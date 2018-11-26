defmodule InterfaceWeb.LobbyChannel do
  use InterfaceWeb, :channel

  def join("lobby", _params, socket) do
    {:ok, %{}, socket}
  end

  def handle_in("new_game", _params, socket) do
    game_id = unique_game_id()
    {:ok, _state} = Game.Supervisor.start_game(game_id)
    {:reply, {:ok, %{game_id: game_id}}, socket}
  end

  defp unique_game_id() do
    System.unique_integer([:positive])
    |> to_string()
    |> String.reverse()
    |> String.slice(1..6)
  end
end
