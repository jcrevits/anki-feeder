defmodule AnkiFeederWeb.TermLive.Index do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      # TODO make per_page modifiable in UI
      |> assign(page: 1, per_page: 20)
      |> load_terms()

    {:ok, socket, temporary_assigns: [terms: []]}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> load_terms()

    {:noreply, socket}
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

  defp load_terms(%{assigns: %{page: page, per_page: per_page}} = socket) do
    assign(socket, terms: Mnemo.list_terms(page, per_page))
  end
end
