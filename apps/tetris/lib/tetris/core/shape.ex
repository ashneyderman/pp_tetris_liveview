defmodule Tetris.Core.Shape do
  @moduledoc """
  This module defines methods and structures that manipulate tetris shapes.

  Here is an example of the basic tetris shape (* - cell that is on,
  o - center of rotation)

  * * ( 0, 1)
  o   ( 0, 0)
  *   ( 0,-1)
      ( 1, 1)

  The shape is a list of coordinates occupied by non-empty cells. To
  rotate the shape then we need to perform geometric transformation of
  the shape's coordinates. In math terms such transformation translates
  to multiplication of coordinate matrix shown above by rotation transform
  matrix below:

    (cos t, -sin t)
    (sin t,  cos t)

  where t is the angle by which we rotate. For example, to rotate the
  shape by 90 degrees clock-wise the transformation matrix becomes:

    (0, -1)
    (1,  0)

  Shifting the shape by some delta along x and/or y axis can be done
  in a similar manner.

  Note that shape coordinates might contain numbers that end in .5.
  That is done in the interest of making shapes to rotate around their
  natural center. The shape is usually manipulated within the context
  of a `Field`. The cell coordinates in that field are integers,
  therefore some ofthe operations of this module will have
  `:snap_to_field` option to help ease of translation between shapes
  and the field they are manipulated within.
  """

  alias MatrixUtils
  alias Tetris.Core.Shape

  @type color :: :red | :blue | :green
  @type rotation :: :cw | :ccw

  @type t :: %__MODULE__{
          coords: Matrix.matrix(),
          color: color()
        }

  defstruct coords: [],
            color: nil

  @doc """
  Rotates the shape.

  The angle of rotation is always 90 degrees either clock-wise with
  `:cw` parameter or 90 degrees counter clock-wise with `:ccw` parameter.
  """
  @spec rotate(Shape.t(), rotation()) :: Shape.t()
  def rotate(%Shape{} = shape, :cw) do
    do_rotate(shape, :math.pi() / 2)
  end

  def rotate(%Shape{} = shape, :ccw) do
    do_rotate(shape, -1 * (:math.pi() / 2))
  end

  @spec do_rotate(Shape.t(), float()) :: Shape.t()
  defp do_rotate(%Shape{coords: coords} = shape, angle) do
    c00 = :math.cos(angle) |> round
    c01 = (:math.sin(angle) |> round) * -1
    c10 = :math.sin(angle) |> round
    c11 = :math.cos(angle) |> round
    rotation = [[c00, c01], [c10, c11]]
    new_coords = Matrix.mult(coords, rotation)
    %Shape{shape | coords: new_coords}
  end

  @doc """
  Shifts shape along x and y coordinates by deltas provided.

  ## Options

    * `:snap_to_field` - If this option is set to true shift operation will
      make sure that the shift results in all integer coordinates of
      the shape. The `snaping` is performed in down and right directions.
  """
  @spec shift(Shape.t(), number(), number(), Keyword.t()) :: Shape.t()
  def shift(%Shape{coords: coords} = shape, delta_x, delta_y, opts \\ []) do
    snap? = Keyword.get(opts, :snap_to_field, false)
    shift_matrix = coords |> Enum.reduce([], fn _, acc -> [[delta_x, delta_y] | acc] end)

    new_coords =
      coords
      |> Matrix.add(shift_matrix)
      |> snap(snap?)

    %Shape{shape | coords: new_coords}
  end

  @spec pick_starting_y_coord(Shape.t()) :: integer()
  def pick_starting_y_coord(shape) do
    # detect max y
    max_y = shape.coords |> Enum.reduce(-1, fn [_, y], c ->
      if y > c, do: y, else: c
    end)

    (-1) * (round(max_y + 0.1) + 1)
  end

  @spec snap(Matrix.matrix(), boolean()) :: Matrix.matrix()
  defp snap(coords, false), do: coords

  defp snap(coords, true),
    do: MatrixUtils.apply_each_cell(coords, fn cell -> round(cell + 0.1) end)
end
