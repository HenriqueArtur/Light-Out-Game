defmodule LightOutGameWeb.Levels do
  use LightOutGameWeb, :live_view
  import LightsOutGameWeb.LevelsReferences

  def mount(_params, _session, socket) do
    levels = levels_references() |> Map.keys()
    {:ok, assign(socket, levels: levels)}
  end
end