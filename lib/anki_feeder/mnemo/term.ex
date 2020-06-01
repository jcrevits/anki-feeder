defmodule AnkiFeeder.Mnemo.Term do
  use Ecto.Schema
  import Ecto.Changeset

  schema "terms" do
    field :kanji, :string, nullable: false
    field :kanji_others, :string, nullable: false
    field :reading, :string, nullable: false
    field :definition, :string, nullable: false
    field :misc, :string, nullable: true

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:kanji, :kanji_others, :reading, :definition, :misc])
    |> validate_required([:kanji, :kanji_others, :reading, :definition])
  end
end
