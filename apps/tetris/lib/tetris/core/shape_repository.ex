defmodule Tetris.Core.ShapeRepository do
  @moduledoc """
  This module defines a set of predefined `Tetris.Shape`s and methods to retrieve them.
  """
  alias Tetris.Core.Shape

  @shapes_repository [
    # stick
    %Shape{coords: [[0, 1.5], [0, 0.5], [0, -0.5], [0, -1.5]]},
    # square
    %Shape{coords: [[0.5, 0.5], [0.5, -0.5], [-0.5, -0.5], [-0.5, 0.5]]},
    # 7
    %Shape{coords: [[-1, 1], [0, 1], [0, 0], [-1, 0]]},
    # T
    %Shape{coords: [[-1, 1], [0, 1], [1, 1], [0, 0], [0, -1]]},
    # S
    %Shape{coords: [[0, 1], [0, 0], [-1, 0], [-1, -1]]},
    # S mirrored
    %Shape{coords: [[0, 1], [0, 0], [1, 0], [1, -1]]},
    # 7 mirrored
    %Shape{coords: [[1, 1], [0, 1], [0, 0], [0, -1]]}
  ]

  @doc """
  Returns a list of all pre-defined shapes.
  """
  @spec all_shapes() :: list()
  def all_shapes do
    @shapes_repository
  end

  @doc """
  Selects a random shape from the repository.
  """
  @spec select_random_shape() :: Shape.t()
  def select_random_shape do
    repo = all_shapes()
    idx = :rand.uniform(Enum.count(repo)) - 1
    Enum.at(repo, idx)
  end
end
