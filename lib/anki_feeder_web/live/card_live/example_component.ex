defmodule AnkiFeederWeb.Card.ExampleComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex flex-col">
      <%= if length(@examples) > 0 do %>
        <em>Found <%= length(@examples) %>+ examples.</em>
      <% end %>

      <%= for example <- @examples do %>
        <hr class="example-hr" />
        <div class="row term-search-row <%= if @selected_example.id == to_string(example.id), do: ~s(selected-example) %> "
            phx-click="use-example"
            phx-value-example_id="<%= example.id %>"
            phx-value-japanese="<%= example.japanese %>"
            phx-value-english="<%= example.english %>" >
          <div class="column">
            <%= example.japanese %>
          </div>
          <div class="column">
            <%= example.english %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
