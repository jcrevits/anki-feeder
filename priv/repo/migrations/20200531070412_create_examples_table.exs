defmodule AnkiFeeder.Repo.Migrations.CreateExamplesTable do
  use Ecto.Migration

  def change do
    create table(:examples) do
      add :japanese, :text, null: false
      add :english, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:examples, [:japanese])
    create index(:examples, [:english])
  end
end
