defmodule Game.Rules do
  @win_combos [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  def winning_combo?([:x, :x, :x]), do: true
  def winning_combo?([:o, :o, :o]), do: true
  def winning_combo?(_), do: false

  def get_winner(board) do
    combo =
      Enum.find(@win_combos, fn combo ->
        Enum.map(combo, fn x -> Enum.at(board, x) end)
        |> winning_combo?
      end)

    case combo do
      nil -> nil
      [i, _, _] -> Enum.at(board, i)
    end
  end
end
