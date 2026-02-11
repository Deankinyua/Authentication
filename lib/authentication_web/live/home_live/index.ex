defmodule AuthenticationWeb.HomeLive.Index do
  use AuthenticationWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div>If you're seeing this page it means you were successfully authenticated</div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
