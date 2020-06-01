defmodule AnkiFeeder.Mnemo do
  @moduledoc """
  The Mnemo context.
  """

  import Ecto.Query, warn: false

  alias AnkiFeeder.Mnemo.{Example, Term}
  alias AnkiFeeder.Repo

  @doc """
  Returns the list of terms.

  ## Examples

      iex> list_terms()
      [%Term{}, ...]

  """
  def list_terms do
    query = from t in Term, select: t

    query
    |> limit(20)
    |> Repo.all()
  end

  @doc """
  Gets a single term.

  Raises `Ecto.NoResultsError` if the Term does not exist.

  ## Examples

      iex> get_term!(123)
      %Term{}

      iex> get_term!(456)
      ** (Ecto.NoResultsError)

  """
  def get_term!(id), do: Repo.get!(Term, id)

  @doc """
  Creates a term.

  ## Examples

      iex> create_term(%{field: value})
      {:ok, %Term{}}

      iex> create_term(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert()
  end

  def lookup_term(search) do
    lookup_term_exact(search)
  end

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

    query |> limit(20) |> Repo.all()
  end
end
