defmodule AnkiFeederWeb.CardLiveTest do
  use AnkiFeederWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "new cards" do
    test "load page", %{conn: conn} do
      {:ok, view, html} = live conn, Routes.card_new_path(conn, :new)

      assert html =~ "Add terms"
      assert view |> element("#skip-button") |> render() =~ ~s(disabled=\"disabled\")
      assert view |> element("#clear-button") |> render() =~ ~s(disabled=\"disabled\")

      refute has_element?(view, "#modal")
      refute has_element?(view, "#example-row-")
      refute has_element?(view, "#add-card-form")

      assert has_element?(view, "#search-input")
    end
  end
end
