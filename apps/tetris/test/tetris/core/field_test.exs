defmodule Tetris.Core.FieldTest do
  use ExUnit.Case

  alias Tetris.Core.{Field, Shape}

  describe "new/3" do
    test "simple field creation" do
      assert {:ok, %Field{cells: [[0, 0], [0, 0]]}} = Field.new(2, 2, 0)
    end

    test "fails when width or height are negative" do
      assert {:error, _} = Field.new(-2, 2)
      assert {:error, _} = Field.new(2, -2)
    end
  end

  describe "capture/4" do
    test "basic capture" do
      {:ok, field} = Field.new(2, 2)
      shape = %Shape{coords: [[0, 0]]}
      assert {0, %Field{cells: [[1, 0], [0, 0]]}} = Field.capture(field, shape, 0, 0)
    end

    test "capture with elimination" do
      field = %Field{cells: [[0, 1], [1, 1]], width: 2, height: 2}
      shape = %Shape{coords: [[0, 0]]}
      assert {2, %Field{cells: [[0, 0], [0, 0]]}} = Field.capture(field, shape, 0, 0)
    end

    test "basic error - matrix lib failure" do
      {:ok, field} = Field.new(2, 2)
      shape = %Shape{coords: [[-1, 0], [0, 0], [1, 0]]}
      assert catch_error(Field.capture(field, shape, 0, 2))
    end
  end

  describe "can_move?/4" do
    test "can move when all of the shape ends up in the field" do
      {:ok, field} = Field.new(2, 2)
      shape = %Shape{coords: [[0, 0]]}
      assert true == Field.can_move?(field, shape, 1, 1)
      assert true == Field.can_move?(field, shape, 0, 0)
      assert true == Field.can_move?(field, shape, 0, 1)
      assert true == Field.can_move?(field, shape, 1, 0)
      assert true == Field.can_move?(field, shape, 1, -3)
    end

    test "snap_to_field parameter works" do
      {:ok, field} = Field.new(2, 2)
      bar = %Shape{coords: [[0.5, 0], [-0.5, 0]]}
      assert true == Field.can_move?(field, bar, 0, 0)
      assert true == Field.can_move?(field, bar, 0, 1)
      assert false == Field.can_move?(field, bar, 1, 0)
      assert false == Field.can_move?(field, bar, 1, 1)

      stick = Shape.rotate(bar, :cw)
      assert true == Field.can_move?(field, stick, 0, 0)
      assert true == Field.can_move?(field, stick, 1, 0)
      assert false == Field.can_move?(field, stick, 2, 0)
      assert false == Field.can_move?(field, stick, -1, 0)
      assert false == Field.can_move?(field, stick, 0, 1)
      assert false == Field.can_move?(field, stick, 1, 1)
    end

    test "can not move if the shape is out of bounds" do
      {:ok, field} = Field.new(2, 2)
      shape = %Shape{coords: [[0, 0]]}
      assert false == Field.can_move?(field, shape, 2, 0)
      assert false == Field.can_move?(field, shape, -1, 0)
      assert false == Field.can_move?(field, shape, 0, 2)
    end
  end
end
