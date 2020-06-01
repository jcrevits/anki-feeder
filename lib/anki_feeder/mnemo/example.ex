defmodule AnkiFeeder.Mnemo.Example do
  use Ecto.Schema
  import Ecto.Changeset

  schema "examples" do
    field :japanese, :string, nullable: false
    field :english, :string, nullable: false

    timestamps()
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:japanese, :english])
    |> validate_required([:japanese, :english])
  end
end
