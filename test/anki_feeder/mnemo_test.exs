defmodule AnkiFeeder.MnemoTest do
  use AnkiFeeder.DataCase

  alias AnkiFeeder.Mnemo

  describe "terms" do
    @valid_attrs %{
      definition: "some definition",
      kanji: "人見知り",
      kanji_others: "人みしり",
      reading: "ひとみしり"
    }

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
  end
end
