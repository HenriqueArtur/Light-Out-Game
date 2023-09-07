defmodule LightOutGameWeb.Light do
  use Phoenix.Component

  def light(assigns) do
    ~H"""
    <button
      class={"block h-20 px-4 py-6 text-center border rounded #{if !@value do "bg-stone-300 hover:bg-stone-400" else "bg-orange-300 hover:bg-orange-400" end}"}
      phx-click="toggle"
      phx-value-x={@x}
      phx-value-y={@y}
      data-on={@value}></button>
    """
  end
end