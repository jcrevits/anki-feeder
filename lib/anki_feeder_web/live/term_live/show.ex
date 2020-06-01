defmodule AnkiFeederWeb.TermLive.Show do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:term, Mnemo.get_term!(id))}
  end

  defp page_title(:show), do: "Show Term"
end
