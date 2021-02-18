defmodule AnkiFeeder.StatusChecker do
  use GenServer
  require Logger

  alias AnkiFeeder.AnkiConnect

  @check_timer :timer.seconds(2)

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_init_arg) do
    Logger.info("Starting #{inspect(__MODULE__)}")
    schedule_check()
    {:ok, {get_status()}}
  end

  def handle_info(:check, {_is_running?}) do
    is_running? = get_status()
    AnkiFeederWeb.Endpoint.broadcast!("anki-connect", "status-update", %{status: is_running?})

    schedule_check()

    {:noreply, {is_running?}}
  end

  defp get_status() do
    AnkiConnect.is_running?()
  end

  defp schedule_check() do
    Process.send_after(self(), :check, @check_timer)
  end
end
