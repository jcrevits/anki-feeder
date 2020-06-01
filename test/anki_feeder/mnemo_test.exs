defmodule AnkiFeeder.MnemoTest do
  use AnkiFeeder.DataCase

  alias AnkiFeeder.Mnemo

  describe "terms" do
    alias AnkiFeeder.Mnemo.Term

    @valid_attrs %{definition: "some definition", kanji: "some kanji", reading: "some reading"}
    @update_attrs %{definition: "some updated definition", kanji: "some updated kanji", reading: "some updated reading"}
    @invalid_attrs %{definition: nil, kanji: nil, reading: nil}

    def term_fixture(attrs \\ %{}) do
      {:ok, term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mnemo.create_term()

      term
    end

    test "list_terms/0 returns all terms" do
      term = term_fixture()
      assert Mnemo.list_terms() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert Mnemo.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      assert {:ok, %Term{} = term} = Mnemo.create_term(@valid_attrs)
      assert term.definition == "some definition"
      assert term.kanji == "some kanji"
      assert term.reading == "some reading"
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mnemo.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      assert {:ok, %Term{} = term} = Mnemo.update_term(term, @update_attrs)
      assert term.definition == "some updated definition"
      assert term.kanji == "some updated kanji"
      assert term.reading == "some updated reading"
    end

    test "update_term/2 with invalid data returns error changeset" do
      term = term_fixture()
      assert {:error, %Ecto.Changeset{}} = Mnemo.update_term(term, @invalid_attrs)
      assert term == Mnemo.get_term!(term.id)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = Mnemo.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Mnemo.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = Mnemo.change_term(term)
    end
  end
end
