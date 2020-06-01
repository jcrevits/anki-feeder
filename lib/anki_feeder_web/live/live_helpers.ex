defmodule AnkiFeederWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `AnkiFeederWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, AnkiFeederWeb.TermLive.FormComponent,
        id: @term.id || :new,
        action: @live_action,
        term: @term,
        return_to: Routes.term_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, AnkiFeederWeb.ModalComponent, modal_opts)
  end
end
