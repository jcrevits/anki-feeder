defmodule AnkiFeederWeb.PageLiveTest do
  use AnkiFeederWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "AnkiFeeder"
    assert render(page_live) =~ "search for a word"
  end
end
