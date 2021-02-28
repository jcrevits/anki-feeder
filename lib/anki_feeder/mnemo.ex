defmodule AnkiFeeder.Mnemo do
  @moduledoc """
  The Mnemo context.
  """

  import Ecto.Query, warn: false

  alias AnkiFeeder.Mnemo.{Example, Term}
  alias AnkiFeeder.Repo

  def list_terms do
    query = from t in Term, select: t

    query
    |> Repo.all()
  end

  def list_terms(page, per_page) do
    query =
      from t in Term,
        offset: ^((page - 1) * per_page),
        limit: ^per_page,
        select: t

    query
    |> Repo.all()
  end

  def get_term!(id), do: Repo.get!(Term, id)

  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  def lookup_term(nil), do: []
  def lookup_term(search), do: lookup_term_exact(search)

  def lookup_term_exact(search) do
    query = from t in Term, where: t.kanji == ^search, select: t

    query |> Repo.all()
  end

  def lookup_term_starts_with(search) do
    wild_search = "#{search}%"

    query = from t in Term, where: ilike(t.kanji, ^wild_search), select: t

    query |> Repo.all()
  end

  def lookup_term_ends_with(search) do
    wild_search = "%#{search}"

    query = from t in Term, where: ilike(t.kanji, ^wild_search), select: t

    query |> Repo.all()
  end

  def lookup_examples(word) do
    wild_search = "%#{word}%"

    query = from e in Example, where: ilike(e.japanese, ^wild_search), select: e

    query |> limit(10) |> Repo.all()
  end
end
