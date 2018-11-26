defmodule Game do
  alias Game.{Board, Rules}

  defstruct [:board, :turn, :winner, players: [], over: false]

  @players [:x, :o]

  def new(turn \\ :x) do
    %Game{board: Board.new(), turn: turn}
  end

  def join(%Game{players: players}) when length(players) == 2 do
    {:error, "No more players allowed"}
  end

  def join(%Game{players: players} = game) do
    player = next_player(players)
    {:ok, %{game | players: [player | players]}, player}
  end

  def leave(%Game{players: players} = game, player) when player in @players do
    {:ok, %{game | players: List.delete(players, player)}}
  end

  def make_move(%Game{over: true}, _, _), do: {:error, "Game over"}
  def make_move(%Game{turn: turn}, player, _) when turn !== player, do: {:error, "Not your turn"}

  def make_move(%Game{board: board} = game, player, position) do
    case Board.put(board, position, player) do
      {:ok, board} ->
        game_updated =
          game
          |> update_board(board)
          |> update_turn()
          |> check_game_over()

        {:ok, game_updated}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def opposite_player(:x), do: :o
  def opposite_player(:o), do: :x

  defp update_board(game, board), do: %{game | board: board}
  defp update_turn(game), do: %{game | turn: opposite_player(game.turn)}
  defp update_over(game), do: %{game | over: true}
  defp update_winner(game, winner), do: %{game | winner: winner}

  defp next_player([]), do: Enum.at(@players, 0)
  defp next_player([player]), do: opposite_player(player)

  defp check_game_over(%{board: board} = game) do
    case Rules.get_winner(board) do
      nil ->
        if Board.full?(board) do
          game |> update_winner(:draw) |> update_over()
        else
          game
        end

      winner ->
        game |> update_winner(winner) |> update_over()
    end
  end
end
