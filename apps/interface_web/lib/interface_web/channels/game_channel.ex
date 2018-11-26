defmodule InterfaceWeb.GameChannel do
  use InterfaceWeb, :channel

  alias InterfaceWeb.{GameView, Presence}

  def join("game:" <> game_id, _params, socket) do
    case Game.Server.join(game_id) do
      {:ok, game, player} ->
        send(self(), {:after_join, player})

        socket = assign(socket, :game_id, to_string(game_id))
        socket = assign(socket, :player, player)

        {:ok, %{player: GameView.present_player(player), game: GameView.game_json(game)}, socket}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_in("make_move", %{"player" => player, "position" => position}, socket) do
    case Game.Server.make_move(socket.assigns.game_id, player_string_to_atom(player), position) do
      {:ok, game} ->
        game_json = Phoenix.View.render(GameView, "game.json", game)
        broadcast!(socket, "make_move", game_json)
        {:reply, {:ok, game_json}, socket}

      {:error, reason} ->
        {:noreply, socket}
    end
  end

  def handle_info({:after_join, player}, socket) do
    game = Game.Server.get_state(socket.assigns.game_id)
    if length(game.players) == 2, do: broadcast(socket, "start_game", %{})

    {:ok, _} = Presence.track(socket, "player:#{player}", %{})

    push(socket, "presence_state", Presence.list(socket))

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    "game:" <> game_id = socket.topic

    {:ok, game} = Game.Server.leave(game_id, socket.assigns.player)

    if length(game.players) > 0 do
      broadcast!(socket, "player_disconnected", %{})
    else
      Game.Server.stop(game_id)
    end

    :ok
  end

  defp player_string_to_atom(str) when is_binary(str) do
    case str do
      "X" -> :x
      "O" -> :o
      _ -> nil
    end
  end
end
