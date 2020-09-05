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

    get_request(payload)
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

    get_request(payload)
  end

  @spec get_request(map) :: {:ok, nil} | {:error, String.t()}
  defp get_request(payload) do
    case HTTPoison.post(@anki_connect_url, Jason.encode!(payload), @json_headers) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Jason.decode!(body) do
          %{"error" => nil} ->
            {:ok, nil}

          %{"error" => reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
