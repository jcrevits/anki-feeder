defmodule AnkiFeederWeb.CardLive.New do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.Mnemo
  alias AnkiFeeder.Mnemo.{AnkiConnect, Example}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        anki_running?: is_anki_running(socket),
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
    results = if search == "", do: nil, else: Mnemo.lookup_term(search)

    socket =
      if results && length(results) == 1 do
        prepare_card(socket, List.first(results).id)
      else
        assign(socket,
          examples: [],
          selected_term: nil
        )
      end

    socket =
      assign(socket,
        term_results: results,
        search_term: search,
        selected_example: %{id: nil, japanese: nil, english: nil}
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("use-term", %{"term_id" => term_id}, socket) do
    socket =
      socket
      |> prepare_card(term_id)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "use-example",
        %{"example_id" => example_id, "japanese" => japanese, "english" => english},
        %{assigns: %{selected_term: selected_term}} = socket
      ) do
    japanese = highlight_in_example(japanese, selected_term)

    selected_example = %Example{id: example_id, japanese: japanese, english: english}

    {:noreply, assign(socket, selected_example: selected_example)}
  end

  @impl true
  def handle_event("save-card", %{"new_card" => new_card}, socket) do
    card_details =
      Map.take(new_card, ["kanji", "reading", "definition", "ja_example", "en_example"])

    case AnkiConnect.create_note(card_details) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Card added to Anki!")
         |> assign(
           search_term: nil,
           term_results: nil,
           examples: [],
           selected_term: nil,
           selected_example: %{id: nil, japanese: nil, english: nil}
         )}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error - #{inspect(reason)}")}
    end
  end

  defp is_anki_running(socket) do
    with true <- connected?(socket),
         {:ok, nil} <- AnkiConnect.version() do
      true
    else
      _ -> false
    end
  end

  defp prepare_card(socket, term_id) do
    selected_term = Mnemo.get_term!(term_id)
    examples = Mnemo.lookup_examples(selected_term.kanji)

    assign(socket, selected_term: selected_term, examples: examples)
  end

  defp highlight_in_example(text, term) do
    String.replace(
      text,
      term.kanji,
      ~s(<b><font color="#fc0107">#{term.kanji}</font></b>)
    )
  end
end
