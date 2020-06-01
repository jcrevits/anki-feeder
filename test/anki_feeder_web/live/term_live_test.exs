defmodule AnkiFeederWeb.TermLiveTest do
  use AnkiFeederWeb.ConnCase

  import Phoenix.LiveViewTest

  alias AnkiFeeder.Mnemo

  @create_attrs %{
    definition: "some definition",
    kanji: "人見知り",
    kanji_others: "人みしり",
    reading: "ひとみしり"
  }

  defp fixture(:term) do
    {:ok, term} = Mnemo.create_term(@create_attrs)
    term
  end

  defp create_term(_) do
    term = fixture(:term)
    %{term: term}
  end

  describe "Index" do
    setup [:create_term]

    test "lists all terms", %{conn: conn, term: term} do
      {:ok, _index_live, html} = live(conn, Routes.term_index_path(conn, :index))

      assert html =~ "Listing Terms"
      assert html =~ term.definition
    end
  end

  describe "Show" do
    setup [:create_term]

    test "displays term", %{conn: conn, term: term} do
      {:ok, _show_live, html} = live(conn, Routes.term_show_path(conn, :show, term))

      assert html =~ "Show Term"
      assert html =~ term.definition
    end
  end
end
