defmodule LightOutGameWeb.Board do
  use LightOutGameWeb, :live_view
  import LightsOutGameWeb.LevelsReferences

  def mount(_params, _session, socket) do
    levels = levels_references() |> Map.keys()
    {:ok, assign(socket, grid: %{}, win: false, levels_qnt: length(levels))}
  end

  def handle_params(params, _uri, socket) do
    grid_clean = reset_grid()
    level = String.to_integer(params["level_id"]) 
    grid = load_level(grid_clean, level)
    {:noreply, assign(socket, grid: grid, win: false, level: level)}
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
    if connected?(socket) and win, do: Process.send_after(self(), :show_win, 0)

    socket = assign(socket, grid: update_grid, win: win)
    case win do
      true -> {:noreply, push_event(socket, "game-over", %{win: win})}
      _ -> {:noreply, socket}
    end
  end

  def handle_event("reset", _params, socket) do
    grid_clean = reset_grid()
    level = socket.assigns.level
    grid = load_level(grid_clean, level)
    {:noreply, assign(socket, grid: grid, win: false, level: level)}
  end

  def handle_event("to-home", _params, socket), do: {:noreply, push_navigate(socket, to: "/")}

  def handle_event("next", _params, socket) do
    levels = socket.assigns.levels_qnt
    current_level = socket.assigns.level
    next_level = Kernel.min(levels, current_level + 1)
    {:noreply, push_patch(socket, to: ~p"/#{next_level}")}
  end

  def handle_event("prev", _params, socket) do
    current_level = socket.assigns.level
    prev_level = Kernel.max(1, current_level - 1)
    {:noreply, push_patch(socket, to: ~p"/#{prev_level}")}
  end

  def handle_info(:show_win, socket) do
    # send_update , id: "modal", options: %{win: true}
    LightOutGameWeb.Win.show_win("modal")
    {:noreply, assign(socket, :win, true)}
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

  defp reset_grid, do: (for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false})

  defp load_level(grid, level_id) do
    levels_references()
    |> Map.get(level_id)
    |> then(fn level -> setup_tiles(grid, level) end)
  end

  defp setup_tiles(grid, []), do: grid

  defp setup_tiles(grid, [{x, y} | rest]) do
    grid
    |> Map.put({x, y}, true)
    |> setup_tiles(rest)
  end
end