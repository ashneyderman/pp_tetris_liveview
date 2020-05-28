defmodule TetrisWeb.TetrisLive do
  use TetrisWeb, :live_view

  @default_cell_height 26 # in pixels
  @default_cell_width  26 # in pixels
  @field_delta_y 40
  @default_level 1
  @field_height 20 # in cells
  @field_width 16  # in cells

  alias Tetris.Core.Shape

  def mount(_params, _session, socket) do
    field_attributes = %{
      cell_height: @default_cell_height,
      cell_width: @default_cell_width,
      field_delta_y: @field_delta_y
    }
    new_socket = start_new_game(socket)
    {:ok, assign(new_socket, field_attributes: field_attributes)}
  end

  def render(%{controller_state: %{game_state: :over, score: score}} = assigns) do
    ~L"""
    <div class="tetris-container" phx-window-keydown="keypressed">
      <div class="game-over">
        <h1>GAME OVER <small>SCORE: <%= score %></h1>
        <button phx-click="new_game">NEW GAME</button>
      </div>
    </div>
    """
  end

  def render(%{controller_state: %{score: score}} = assigns) do
    ~L"""
      <div class="tetris-container" phx-window-keydown="keypressed">
      <%= live_component @socket, TetrisWeb.Tetris.Legend, score: score %>
      <%= live_component @socket, TetrisWeb.Tetris.Field,
            controller_state: @controller_state,
            field_attributes: @field_attributes %>
      </div>
    """
  end

  def handle_info({:state_change,
        %Tetris.GameController{
          score: score,
          game_state: game_state
        } = state}, socket) do

    new_socket =
      socket
      |> assign(:game_state, game_state)
      |> assign(:controller_state, state)
      |> assign(:score, score)
      |> assign(:width, @default_cell_width)
      |> assign(:height, @default_cell_height)

    {:noreply, new_socket}
  end

  def handle_event("keypressed", %{"key" => "ArrowRight"}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :right}, [])
    {:noreply, socket}
  end

  def handle_event("keypressed", %{"key" => "ArrowLeft"}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :left}, [])
    {:noreply, socket}
  end

  def handle_event("keypressed", %{"key" => "ArrowUp"}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :rotate_ccw}, [])
    {:noreply, socket}
  end

  def handle_event("keypressed", %{"key" => "ArrowDown"}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :rotate_cw}, [])
    {:noreply, socket}
  end

  def handle_event("keypressed", %{"key" => "Escape"}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :toggle_state}, [])
    {:noreply, socket}
  end

  def handle_event("keypressed", %{"key" => " "}, socket) do
    gc = socket.assigns.game_controller
    Process.send(gc, {:key_press, :space}, [])
    {:noreply, socket}
  end

  # def handle_event("keypressed", %{"key" => key}, socket) do
  #   {:noreply, socket}
  # end

  def handle_event("new_game", _, socket) do
    {:noreply, start_new_game(socket)}
  end

  def handle_event(event, msg, socket) do
    {:noreply, socket}
  end

  defp start_new_game(socket) do
    if connected?(socket) do
      {:ok, gc} = Tetris.GameController.start_supervised(%{
        state_change_listener: self(),
        level: @default_level,
        height: @field_height,
        width: @field_width})

      controller_state = Tetris.GameController.controller_state(gc)

      socket
      |> assign(:game_controller, gc)
      |> assign(:controller_state, controller_state)
    else
      assign(socket, :controller_state, %Tetris.GameController{})
    end
  end
end
