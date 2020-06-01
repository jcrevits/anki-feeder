defmodule AnkiFeederWeb.TermLive.Index do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :terms, list_terms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Terms")
    |> assign(:term, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    term = Mnemo.get_term!(id)
    {:ok, _} = Mnemo.delete_term(term)

    {:noreply, assign(socket, :terms, list_terms())}
  end

  defp list_terms do
    Mnemo.list_terms()
  end
end
