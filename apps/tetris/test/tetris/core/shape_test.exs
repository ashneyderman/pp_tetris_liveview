defmodule Tetris.Core.ShapeTest do
  use ExUnit.Case

  alias Tetris.Core.{Shape, ShapeRepository}

  @basic_shape %Shape{coords: [[0, 1], [0, 0], [0, -1]]}

  describe "rotate/2" do
    test "rotate 4 times cw or ccw results in the same shape" do
      shape_cw =
        Enum.reduce(1..4, @basic_shape, fn _, shape ->
          Shape.rotate(shape, :cw)
        end)

      assert shape_cw == @basic_shape

      shape_ccw =
        Enum.reduce(1..4, @basic_shape, fn _, shape ->
          Shape.rotate(shape, :ccw)
        end)

      assert shape_ccw == @basic_shape
    end

    test "rotate once works" do
      assert [[1, 0], [0, 0], [-1, 0]] == Shape.rotate(@basic_shape, :cw).coords
      assert [[-1, 0], [0, 0], [1, 0]] == Shape.rotate(@basic_shape, :ccw).coords
    end
  end

  # tests for shift operation still todo

  describe "pick_starting_y_coord/1" do
    test "picks the coordinate that makes the top's most point of the shape to end up on the broder of the field" do
      Enum.each(ShapeRepository.all_shapes(), fn shape ->
        y = Shape.pick_starting_y_coord(shape)
        shifted_shape = Shape.shift(shape, 0, y)
        max_y = shifted_shape.coords |> Enum.map(fn [_, cy] -> cy end) |> Enum.max()
        assert round(max_y + 0.1) == -1
      end)
    end
  end
end
