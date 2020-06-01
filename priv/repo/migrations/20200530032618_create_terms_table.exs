defmodule AnkiFeeder.Repo.Migrations.CreateTerms do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :kanji, :text, null: false
      add :kanji_others, :text, null: false
      add :reading, :text, null: false
      add :definition, :text, null: false
      add :misc, :text, null: true

      timestamps()
    end

    create index(:terms, [:kanji])
    create index(:terms, [:reading])
  end
end
