defmodule AnkiFeederWeb.Card.ExampleComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex flex-col flex-shrink px-20">
      <%= if length(@examples) > 0 do %>
        <em>Found <%= length(@examples) %>+ examples.</em>
      <% end %>

      <%= for example <- @examples do %>
        <hr class="example-hr" />
        <div class="row term-search-row py-2 <%= selected_class(@selected_example, example) %>"
            phx-click="use-example"
            phx-value-example_id="<%= example.id %>"
            phx-value-japanese="<%= example.japanese %>"
            phx-value-english="<%= example.english %>" >
          <div class="column">
            <div class="row">
              <%= example.japanese %>
            </div>
            <div class="row">
              <%= example.english %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp selected_class(selected_example, current_example) do
    if selected_example.id == to_string(current_example.id), do: "selected-example"
  end
end
