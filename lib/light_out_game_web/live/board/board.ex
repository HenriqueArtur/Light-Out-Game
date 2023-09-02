defmodule LightOutGameWeb.Board do
  use LightOutGameWeb, :live_view

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    level1 = %{{2, 0} => true, {2, 2} => true, {2, 4} => true}
    grid = Map.merge(grid, level1)
    {:ok, assign(socket, grid: grid, win: false)}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    update_grid = 
      find_adjacent_tiles(grid_x, grid_y)
      |> Enum.reduce(%{}, fn point, acc ->
        Map.put(acc, point, !grid[point])
      end)
      |> then(fn toggle_grid -> Map.merge(grid, toggle_grid) end)
    win = check_win(update_grid)

    socket = assign(socket, grid: update_grid, win: win)
    case win do
      true -> {:noreply, push_event(socket, "game-over", %{win: win})}
      _ -> {:noreply, socket}
    end
  end

  defp find_adjacent_tiles(x, y) do
    prevX = Kernel.max(0, x - 1)
    nextX = Kernel.min(4, x + 1)
    prevY = Kernel.max(0, y - 1)
    nextY = Kernel.min(4, y + 1)
    [{x, y}, {prevX, y}, {nextX, y}, {x, prevY}, {x, nextY}]
  end

  defp check_win(grid) do
    grid
    |> Map.values()
    |> Enum.all?(&(!&1))
  end
end