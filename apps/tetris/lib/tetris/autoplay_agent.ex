defmodule Tetris.AutoplayAgent do
  @moduledoc """
  This module is the autoplay agent for the game of tetris.

  Note, at the moment nothing intelligent is implmented here.
  """
  use GenServer

  def start_with_defaults() do
    start_supervised(%{
      level: 5,
      height: 18,
      width: 20
    })
  end

  def start_supervised(params) do
    DynamicSupervisor.start_child(
      Tetris.AutoplayAgentsSup,
        %{
          id: Tetris.AutoplayAgent,
          start: {Tetris.AutoplayAgent, :start_link, [params]},
          restart: :temporary
        }
      )
  end

  @spec start_link(Keyword.t()) :: GenServer.on_start
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(%{} = params) do
    params = params |> Map.put(:state_change_listener, self())
    {:ok, gc} = Tetris.GameController.start_supervised(params)
    {:ok, %{game_controller: gc}}
  end

  def handle_info({:state_change, %Tetris.GameController{
                      game_state: :over
                    }}, state) do
    {:stop, :normal, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
