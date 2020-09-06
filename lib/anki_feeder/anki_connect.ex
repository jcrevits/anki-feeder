defmodule AnkiFeeder.Mnemo.AnkiConnect do
  alias HTTPoison
  alias Jason

  # default AnkiConnect URL
  @anki_connect_url "http://localhost:8765"
  @json_headers [{"Content-Type", "application/json"}]

  @deck_name "自分の単語"
  @model_name "自分の日本語"

  @spec version() :: {:ok, nil} | {:error, String.t()}
  def version() do
    payload = %{
      action: "version",
      version: 6
    }

    case request(payload) do
      {:ok, _response} ->
        {:ok, nil}

      error_response ->
        error_response
    end
  end

  @spec deck_names_and_ids() :: {:ok, list(map)} | {:error, String.t()}
  def deck_names_and_ids() do
    payload = %{
      action: "deckNamesAndIds",
      version: 6
    }

    case request(payload) do
      {:ok, response} ->
        response["result"]
        |> Enum.map(fn {name, id} -> %{id: id, name: name} end)

      error_response ->
        error_response
    end
  end

  @spec create_note(map) :: {:ok, nil} | {:error, String.t()}
  def create_note(%{
        "kanji" => kanji,
        "reading" => reading,
        "definition" => definition,
        "ja_example" => ja_example,
        "en_example" => en_example
      }) do
    payload = %{
      action: "addNote",
      version: 6,
      params: %{
        note: %{
          deckName: @deck_name,
          modelName: @model_name,
          fields: %{
            Kanji: kanji,
            Kana: reading,
            Meaning: definition,
            ContextJP: ja_example,
            ContextFREN: en_example
          },
          options: %{
            allowDuplicate: false,
            duplicateScope: "deck"
          }
        }
      }
    }

    request(payload)
  end

  @spec request(map) :: {:ok, any()} | {:error, String.t()}
  defp request(payload) do
    case HTTPoison.post(@anki_connect_url, Jason.encode!(payload), @json_headers) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Jason.decode!(body) do
          %{"error" => nil} = decoded_body ->
            {:ok, decoded_body}

          %{"error" => reason} ->
            {:error, reason}

          _ ->
            {:error, "Could not decode response."}
        end

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "Request error."}
    end
  end
end
