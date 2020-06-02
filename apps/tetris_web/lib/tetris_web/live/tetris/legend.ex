defmodule TetrisWeb.Tetris.Legend do
  @moduledoc """
  Module that is a LiveView component of the legend for tetris game.
  """
  use TetrisWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, score: 0)}
  end

  def render(assigns) do
    ~L"""
    <h3 class="score" style="font-size: 14px;">
          SCORE:&nbsp;<%= @score %>&nbsp;
          Right - Right Arrow; &nbsp;
          Left - Left Arrow; &nbsp;
          CW - Arrow Up; &nbsp;
          CCW - Arrow Down; &nbsp;
          Drop - Space; &nbsp;
          Pause/Restart - Escape; &nbsp;
        </h3>
    """
  end
end
