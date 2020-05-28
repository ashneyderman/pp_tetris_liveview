defmodule Tetris.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, [adapter: Phoenix.PubSub.PG2, name: Tetris.PubSub]},
      # Start a worker by calling: Tetris.Worker.start_link(arg)
      # {Tetris.Worker, arg}
      {DynamicSupervisor, strategy: :one_for_one, name: Tetris.GameControllerSup},
      {DynamicSupervisor, strategy: :one_for_one, name: Tetris.AutoplayAgentsSup}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tetris.Supervisor)
  end
end
