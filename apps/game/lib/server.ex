defmodule Game.Server do
  use GenServer

  # CLIENT API

  def start_link(id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  def get_state(id) do
    GenServer.call(via_tuple(id), :get_state)
  end

  def make_move(id, player, position) do
    GenServer.call(via_tuple(id), {:make_move, player, position})
  end

  def join(id) do
    GenServer.call(via_tuple(id), :join)
  end

  def leave(id, player) do
    GenServer.call(via_tuple(id), {:leave, player})
  end

  def stop(id) do
    GenServer.stop(via_tuple(id), :shutdown)
  end

  defp via_tuple(game_id) do
    {:via, Registry, {Registry.ViaGame, game_id}}
  end

  # CALLBACKS

  @impl true
  def init(_args) do
    {:ok, Game.new()}
  end

  @impl true
  def handle_call(:get_state, _form, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:make_move, player, position}, _from, state) do
    case Game.make_move(state, player, position) do
      {:ok, game} ->
        {:reply, {:ok, game}, game}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:join, _from, state) do
    case Game.join(state) do
      {:ok, new_state, player} -> {:reply, {:ok, new_state, player}, new_state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call({:leave, player}, _from, state) do
    case Game.leave(state, player) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def terminate(_reason, _status) do
    :ok
  end
end
