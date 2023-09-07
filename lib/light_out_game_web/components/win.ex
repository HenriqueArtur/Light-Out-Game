defmodule LightOutGameWeb.Win do
  use Phoenix.Component
  import LightOutGameWeb.CoreComponents
  import LightOutGameWeb.IconButton
  alias Phoenix.LiveView.JS

  attr :modal_id, :string
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}

  def win(assigns) do
    ~H"""
    <div
      id={assigns.modal_id}
      phx-mounted={assigns.show && show_modal(assigns.modal_id)}
      phx-remove={hide_modal(assigns.modal_id)}
      data-cancel={JS.exec(assigns.on_cancel, "phx-remove")}
      class={"relative z-50 #{if !assigns.show do "hidden" else "" end}"}
    >
      <div id={"#{assigns.modal_id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{assigns.modal_id}-title"}
        aria-describedby={"#{assigns.modal_id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{assigns.modal_id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{assigns.modal_id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{assigns.modal_id}")}
              class={"shadow-zinc-700/10 ring-zinc-700/10 relative rounded-2xl bg-white p-14 shadow-lg ring-1 transition #{if !assigns.show do "hidden" else "" end}"}
            >
              <div id={"#{assigns.modal_id}-content"} class="flex flex-col">
                <h3 class="text-3xl text-center mb-4" >You won!</h3>
                <div class="flex flex-col max-w-lg mx-auto">
                  <div class="grid grid-cols-2 gap-2">
                    <.icon_button icon="hero-chevron-right" action="next" />
                    <.icon_button icon="hero-home" action="to-home" />
                  </div>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_win(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_win(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end