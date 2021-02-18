defmodule AnkiFeederWeb.CardLive.New do
  use AnkiFeederWeb, :live_view

  alias AnkiFeeder.AnkiConnect
  alias AnkiFeeder.Mnemo
  alias AnkiFeeder.Mnemo.Example

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        anki_running?: AnkiConnect.is_running?(),
        multiterms: [],
        search_term: nil,
        selected_term: nil,
        term_results: nil,
        examples: [],
        selected_example: %{id: nil, japanese: nil, english: nil}
      )

    AnkiFeederWeb.Endpoint.subscribe("anki-connect")

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("search-terms", %{"search" => search}, socket) do
    {:noreply, search_term(socket, search)}
  end

  @impl true
  def handle_event("use-term", %{"term_id" => term_id}, socket) do
    term = Mnemo.get_term!(term_id)

    {:noreply, prepare_card(socket, term)}
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
        multiterms = List.delete_at(socket.assigns.multiterms, 0)

        {
          :noreply,
          socket
          |> put_flash(:info, "Card added to Anki!")
          |> assign(
            search_term: nil,
            term_results: nil,
            examples: [],
            selected_term: nil,
            selected_example: %{id: nil, japanese: nil, english: nil},
            multiterms: multiterms
          )
          |> search_term(List.first(multiterms))
        }

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error - #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event(
        "save-multiterms",
        %{"multiterms" => %{"term-area" => multiterm_input}},
        socket
      ) do
    multiterms = String.split(multiterm_input) |> Enum.map(&String.trim/1)

    socket =
      socket
      |> assign(multiterms: multiterms)
      |> search_term(List.first(multiterms))
      |> push_patch(to: Routes.card_new_path(socket, :new))

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %{event: "status-update", payload: %{status: status}, topic: "anki-connect"},
        socket
      ) do
    {:noreply, assign(socket, anki_running?: status)}
  end

  defp search_term(socket, search) do
    # TODO can this be improved?
    results = if search, do: Mnemo.lookup_term(search), else: nil

    socket =
      if results && length(results) == 1 do
        prepare_card(socket, List.first(results))
      else
        assign(socket,
          selected_term: nil,
          examples: []
        )
      end

    assign(socket,
      term_results: results,
      search_term: search,
      selected_example: %{id: nil, japanese: nil, english: nil}
    )
  end

  defp prepare_card(socket, term) do
    examples = Mnemo.lookup_examples(term.kanji)

    assign(socket, selected_term: term, examples: examples)
  end

  defp highlight_in_example(text, term) do
    String.replace(
      text,
      term.kanji,
      ~s(<b><font color="#fc0107">#{term.kanji}</font></b>)
    )
  end
end
