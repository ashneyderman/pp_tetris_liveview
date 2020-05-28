defmodule TetrisWeb.Tetris.Field do
  use TetrisWeb, :live_component

  alias Tetris.Core.Shape

  @field_delta_y 40

  def mount(socket) do
    {:ok, socket}
  end

  def render(%{controller_state: controller_state, field_attributes: field_attributes} = assigns) do
    %Tetris.GameController{
      field: field,
      current_shape: shape,
      current_shape_coord: [x, y]
    } = controller_state

    %{
      cell_width: cell_width,
      cell_height: cell_height,
      field_delta_y: field_delta_y
    } = field_attributes

    shape_blocks = build_shape_blocks(shape, x, y, 0, field_attributes.field_delta_y, cell_width, cell_height)
    field_blocks = build_field_blocks(field, 0, field_delta_y, cell_width, cell_height)
    bound_blocks = build_bound_blocks(field.width, field.height, 0, field_delta_y, cell_width, cell_height)

    ~L"""
    <%= for field_block <- field_blocks do %>
      <div class="block field"
          style="left: <%= field_block.x %>px;
                 top: <%= field_block.y %>px;
                 width: <%= @field_attributes.cell_width %>px;
                 height: <%= @field_attributes.cell_height %>px;"></div>
    <% end %>
    <%= for block <- bound_blocks do %>
      <div class="block jar"
          style="left: <%= block.x %>px;
                top: <%= block.y %>px;
                width: <%= block.width %>px;
                height: <%= block.height %>px;
      "></div>
    <% end %>
    <%= for shape_block <- shape_blocks do %>
      <div class="block shape"
          style="left: <%= shape_block.x %>px;
                top: <%= shape_block.y %>px;
                width: <%= @field_attributes.cell_width %>px;
                height: <%= @field_attributes.cell_height %>px;
      "></div>
    <% end %>
    """
  end

  defp build_bound_blocks(0, 0, _, _, _, _), do: []
  defp build_bound_blocks(width, height, delta_x, delta_y, cell_width, cell_height) do
    b0 = for row <- 0..(height - 1) do
      %{
        x: -1,
        y: row * cell_height + delta_y,
        height: cell_height,
        width: 1
      }
    end
    b1 = for row <- 0..(height - 1) do
      %{
        x: width * cell_width + 1,
        y: row * cell_height + delta_y,
        height: cell_height + 1,
        width: 1
      }
    end

    b2 = for col <- 0..(width - 1) do
      %{
        x: col * cell_width - 1,
        y: height * cell_height + delta_y,
        height: 2,
        width: cell_width + 3
      }
    end

    b0 ++ b1 ++ b2
  end

  defp build_field_blocks([], _, _, _, _), do: []
  defp build_field_blocks(field, delta_x, delta_y, cell_width, cell_height) do
    for {row, row_number} <- Enum.with_index(field.cells),
        {col, col_number} <- Enum.with_index(row) do
      if col == 1 do
        %{
          x: col_number * cell_width + delta_x,
          y: row_number * cell_height + delta_y
        }
      else
        nil
      end
    end
    |> Enum.filter(&(&1 != nil))
  end

  defp build_shape_blocks(nil, _, _, _, _, _, _), do: []
  defp build_shape_blocks(shape, x, y, delta_x, delta_y, cell_width, cell_height) do
    shape
    |> Shape.shift(x, y, snap_to_field: true)
    |> (fn %Shape{coords: coords} -> coords end).()
    |> Enum.map(fn [col, row] ->
      if col >= 0 && row >= 0 do
        %{
          x: col * cell_width + delta_x,
          y: row * cell_height + delta_y
        }
      else
        nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end
end
