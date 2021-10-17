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
    search_term = if String.trim(search) == "", do: nil, else: search
    socket = socket |> assign(search_term: search_term) |> search_term()

    {:noreply, socket}
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
  def handle_event("skip-term", _params, socket) do
    multiterms = List.delete_at(socket.assigns.multiterms, 0)

    socket =
      socket
      |> assign(multiterms: multiterms, search_term: first_term(multiterms))
      |> search_term()
      |> clear_flash()

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear-terms", _params, socket) do
    socket =
      assign(
        socket,
        search_term: nil,
        term_results: nil,
        examples: [],
        selected_term: nil,
        # TODO make selected_example nil
        selected_example: %{id: nil, japanese: nil, english: nil},
        multiterms: []
      )

    {:noreply, socket}
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
            search_term: first_term(multiterms),
            term_results: nil,
            examples: [],
            selected_term: nil,
            selected_example: %{id: nil, japanese: nil, english: nil},
            multiterms: multiterms
          )
          |> search_term()
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
      |> assign(multiterms: multiterms, search_term: first_term(multiterms))
      |> search_term()
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

  defp search_term(%{assigns: %{search_term: search}} = socket) do
    term_results = Mnemo.lookup_term(search)

    socket =
      case term_results do
        [single_term] -> prepare_card(socket, single_term)
        _ -> assign(socket, selected_term: nil, examples: [])
      end

    selected_example =
      if length(socket.assigns.examples) == 1 do
        example = List.first(socket.assigns.examples)

        %Example{
          id: example.id,
          english: example.english,
          japanese: highlight_in_example(example.japanese, socket.assigns.selected_term)
        }
      else
        %{id: nil, japanese: nil, english: nil}
      end

    assign(socket, term_results: term_results, selected_example: selected_example)
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

  defp first_term(terms), do: Enum.at(terms, 0, nil)
end
