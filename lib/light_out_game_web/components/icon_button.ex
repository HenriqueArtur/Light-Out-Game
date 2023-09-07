defmodule LightOutGameWeb.IconButton do
  use Phoenix.Component
  import LightOutGameWeb.CoreComponents

  attr :disabled, :boolean, default: false
  attr :icon, :string, required: true
  attr :action, :string

  def icon_button(assigns) do
    ~H"""
    <button
      class="block px-4 py-4 text-center border rounded bg-stone-200 hover:bg-stone-400 disabled:opacity-25"
      disabled={@disabled}
      phx-click={"#{@action}"}>
      <.icon name={"#{@icon}"} class="h-6 w-6 border-black" />
    </button>
    """
  end
end