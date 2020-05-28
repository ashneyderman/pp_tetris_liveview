defmodule TetrisWeb.TetrisAdminLive do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Tetris.GameController.subscribe()
    {:ok, fetch_count(socket)}
  end

  def render(assigns) do
    ~L"""
    <div>
      Total Games in Play Now: <%= @count %>
    </div>
    """
  end

  def handle_info({:game_over, _}, socket) do
    {:noreply, fetch_count(socket)}
  end

  def handle_info({:game_started, _} = msg, socket) do
    # IO.puts "msg: #{inspect msg, pretty: true}"
    {:noreply, fetch_count(socket)}
  end

  def handle_info(msg, socket) do
    # IO.puts "other msg: #{inspect msg, pretty: true}"
    {:noreply, socket}
  end

  defp fetch_count(socket) do
    children = Tetris.GameController.all_current_games()
    children_count = Enum.count(children)
    assign(socket, :count, children_count)
  end
end
