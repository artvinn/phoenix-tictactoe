defmodule InterfaceWeb.GameView do
  use InterfaceWeb, :view

  def render("game.json", game) do
    game_json(game)
  end

  def game_json(%{board: board, turn: turn, over: over, winner: winner}) do
    %{
      board: present_board(board),
      turn: present_player(turn),
      over: over,
      winner: present_player(winner)
    }
  end

  def present_player(player), do: player |> to_string |> String.upcase()

  def present_board(board) do
    Enum.map(board, fn value ->
      case value do
        :x -> "X"
        :o -> "O"
        _ -> nil
      end
    end)
  end
end
