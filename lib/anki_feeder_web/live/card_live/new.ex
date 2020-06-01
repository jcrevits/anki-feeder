defmodule AnkiFeederWeb.CardLive.New do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo
  alias AnkiFeeder.Mnemo.{AnkiConnect, Example}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        search_term: nil,
        selected_term: nil,
        term_results: nil,
        examples: [],
        selected_example: %{id: nil, japanese: nil, english: nil}
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("search-terms", %{"search" => search}, socket) do
    IO.inspect(search, label: "search-terms")
    results = if search == "", do: nil, else: Mnemo.lookup_term(search)

    if results && length(results) == 1 do
      send(self(), {"use-term", List.first(results).id})
    end

    socket =
      assign(socket, term_results: results, search_term: search, examples: [], selected_term: nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("use-term", %{"term_id" => term_id}, socket) do
    IO.inspect(term_id, label: "use-term")
    {:noreply, prepare_card(socket, term_id)}
  end

  @impl true
  def handle_event(
        "use-example",
        %{"example_id" => example_id, "japanese" => japanese, "english" => english},
        socket
      ) do
    selected_example = %Example{id: example_id, japanese: japanese, english: english}

    {:noreply, assign(socket, selected_example: selected_example)}
  end

  @impl true
  def handle_event(
        "save-card",
        %{
          "new_card" => new_card
        },
        socket
      ) do
    card_details =
      Map.take(new_card, ["kanji", "reading", "definition", "ja_example", "en_example"])

    case AnkiConnect.create_note(card_details) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Card added to Anki!")
         |> assign(search_term: nil)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error - #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_info({"use-term", term_id}, socket) do
    {:noreply, prepare_card(socket, term_id)}
  end

  defp prepare_card(socket, term_id) do
    selected_term = Mnemo.get_term!(term_id)
    examples = Mnemo.lookup_examples(selected_term.kanji)

    assign(socket, selected_term: selected_term, examples: examples)
  end
end
