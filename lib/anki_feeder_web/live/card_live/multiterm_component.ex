defmodule AnkiFeederWeb.CardLive.MultitermComponent do
  use AnkiFeederWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <h1 class="text-4xl font-bold mb-4">Add multiple terms</h1>
      <.form let={f} for={:multiterms} phx_submit="save-multiterms" class="flex flex-col">
        <%= textarea f, "term-area", value: Enum.join(@multiterms, "\n"), class: "w-1/12" %>
        <%= submit "Submit", class: "w-1/12 mt-10", phx_disable_with: "Processing..." %>
      </.form>
    </div>
    """
  end
end
