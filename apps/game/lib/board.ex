defmodule Game.Board do
  # Our game board will be a simple list of 9 elements,
  # with :empty value for empty cell and :x or :o for a captured cell
  def new(), do: List.duplicate(:empty, 9)

  def put(_board, position, _value) when position not in 0..8, do: {:error, "Out of range"}

  def put(_board, _position, value) when value not in [:x, :o],
    do: {:error, "Invalid value. Must be :x or :o"}

  def put(board, position, value) do
    case Enum.at(board, position) do
      :empty ->
        {:ok, List.replace_at(board, position, value)}

      _ ->
        {:error, "Already occupied"}
    end
  end

  def full?(board), do: Enum.all?(board, &(&1 !== :empty))

  def render(board) do
    for row <- Enum.chunk_every(board, 3) do
      for value <- row do
        case value do
          :empty -> IO.write(IO.ANSI.white() <> " #")
          :x -> IO.write(IO.ANSI.red() <> " X")
          :o -> IO.write(IO.ANSI.green() <> " O")
        end
      end

      IO.write("\n")
    end
  end
end
