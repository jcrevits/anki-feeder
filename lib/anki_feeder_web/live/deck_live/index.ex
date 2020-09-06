defmodule AnkiFeederWeb.DeckLive.Index do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo.AnkiConnect

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, decks: AnkiConnect.deck_names_and_ids())
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Listing Decks</h1>

    <table class="table-auto">
      <thead>
        <tr>
          <th>Name</th>
        </tr>
      </thead>
      <tbody id="decks">
        <%= for deck <- @decks do %>
          <tr id="deck-<%= deck.id %>">
            <td><%= deck.name %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
