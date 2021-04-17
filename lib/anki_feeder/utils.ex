defmodule AnkiFeeder.Utils do
  require Logger

  def bulk_insert(records, module, opts \\ []) do
    batch_size = opts[:batch_size] || 1_000

    records
    |> Stream.map(&add_timestamps/1)
    |> Stream.chunk_every(batch_size)
    |> Stream.map(fn batch -> AnkiFeeder.Repo.insert_all(module, batch) end)
    |> Stream.run()
  end

  def add_timestamps(attrs) do
    now = current_timestamp()

    attrs
    |> Map.put(:inserted_at, now)
    |> Map.put(:updated_at, now)
  end

  def current_timestamp() do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end
end
