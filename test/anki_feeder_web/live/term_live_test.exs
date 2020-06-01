defmodule AnkiFeederWeb.TermLiveTest do
  use AnkiFeederWeb.ConnCase

  import Phoenix.LiveViewTest

  alias AnkiFeeder.Mnemo

  @create_attrs %{definition: "some definition", kanji: "some kanji", reading: "some reading"}
  @update_attrs %{definition: "some updated definition", kanji: "some updated kanji", reading: "some updated reading"}
  @invalid_attrs %{definition: nil, kanji: nil, reading: nil}

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

    test "saves new term", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.term_index_path(conn, :index))

      assert index_live |> element("a", "New Term") |> render_click() =~
               "New Term"

      assert_patch(index_live, Routes.term_index_path(conn, :new))

      assert index_live
             |> form("#term-form", term: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#term-form", term: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.term_index_path(conn, :index))

      assert html =~ "Term created successfully"
      assert html =~ "some definition"
    end

    test "updates term in listing", %{conn: conn, term: term} do
      {:ok, index_live, _html} = live(conn, Routes.term_index_path(conn, :index))

      assert index_live |> element("#term-#{term.id} a", "Edit") |> render_click() =~
               "Edit Term"

      assert_patch(index_live, Routes.term_index_path(conn, :edit, term))

      assert index_live
             |> form("#term-form", term: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#term-form", term: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.term_index_path(conn, :index))

      assert html =~ "Term updated successfully"
      assert html =~ "some updated definition"
    end

    test "deletes term in listing", %{conn: conn, term: term} do
      {:ok, index_live, _html} = live(conn, Routes.term_index_path(conn, :index))

      assert index_live |> element("#term-#{term.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#term-#{term.id}")
    end
  end

  describe "Show" do
    setup [:create_term]

    test "displays term", %{conn: conn, term: term} do
      {:ok, _show_live, html} = live(conn, Routes.term_show_path(conn, :show, term))

      assert html =~ "Show Term"
      assert html =~ term.definition
    end

    test "updates term within modal", %{conn: conn, term: term} do
      {:ok, show_live, _html} = live(conn, Routes.term_show_path(conn, :show, term))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Term"

      assert_patch(show_live, Routes.term_show_path(conn, :edit, term))

      assert show_live
             |> form("#term-form", term: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#term-form", term: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.term_show_path(conn, :show, term))

      assert html =~ "Term updated successfully"
      assert html =~ "some updated definition"
    end
  end
end
