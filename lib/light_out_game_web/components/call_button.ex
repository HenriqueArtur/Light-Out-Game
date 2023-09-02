defmodule LightOutGameWeb.CallButton do
  use Phoenix.Component
  import LightOutGameWeb.CoreComponents

  def call_button(assigns) do
    ~H"""
    <a
      href={"#{@link}"}
      class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
    >
      <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
      </span>
      <span class="relative flex items-center gap-4 sm:flex-col">
        <.icon name={"#{@icon}"} class="h-6 w-6" />
        <%= @label %>
      </span>
    </a>
    """
  end
end
