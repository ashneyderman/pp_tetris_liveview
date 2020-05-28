defmodule Tetris.Core.ShapeRepositoryTest do
  use ExUnit.Case

  alias Tetris.Core.{Shape, ShapeRepository}

  describe "repository/0" do
    test "non-empty repository" do
      refute ShapeRepository.all_shapes() |> Enum.empty?()

      ShapeRepository.all_shapes()
      |> Enum.each(fn shape ->
        assert %Shape{} = shape
      end)
    end

    test "all repo shapes obey 360 degree rotation rule" do
      ShapeRepository.all_shapes()
      |> Enum.each(fn init_shape ->
        shape_ccw =
          Enum.reduce(1..4, init_shape, fn _, shape ->
            Shape.rotate(shape, :ccw)
          end)

        assert shape_ccw == init_shape
      end)

      ShapeRepository.all_shapes()
      |> Enum.each(fn init_shape ->
        shape_cw =
          Enum.reduce(1..4, init_shape, fn _, shape ->
            Shape.rotate(shape, :cw)
          end)

        assert shape_cw == init_shape
      end)
    end
  end

  describe "random_shape/0" do
    test "call returns a shape from the repository" do
      all_shapes = ShapeRepository.all_shapes()
      random_shape = ShapeRepository.select_random_shape()

      assert %Shape{} = random_shape
      assert Enum.any?(all_shapes, fn s -> random_shape == s end)
    end
  end
end
