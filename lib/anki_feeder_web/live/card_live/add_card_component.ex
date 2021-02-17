defmodule AnkiFeederWeb.Card.AddCardComponent do
  use Phoenix.LiveComponent

  import Phoenix.HTML.Form

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex flex-col w-1/4">
      <%= case @selected_term do %>
        <% nil -> %>

        <% _ -> %>
          <%= f = form_for(:new_card, "#", phx_submit: "save-card")  %>
            <%= label(f, :kanji) %>
            <%= text_input(f, :kanji, value: @selected_term.kanji) %>

            <%= label(f, :reading) %>
            <%= text_input(f, :reading, value: @selected_term.reading) %>

            <%= label(f, :definition) %>
            <%= text_input(f, :definition, value: @selected_term.definition) %>

            <%= label(f, :ja_example, "Example (Japanese)") %>
            <%= textarea(f, :ja_example, value: @selected_example.japanese) %>

            <%= label(f, :en_example, "Example (English)") %>
            <%= textarea(f, :en_example, value: @selected_example.english) %>

            <%= submit("Add to Anki", disabled: is_card_submittable(@selected_term)) %>
          </form>
      <% end %>
    </div>
    """
  end

  defp is_card_submittable(term), do: term == nil
end
