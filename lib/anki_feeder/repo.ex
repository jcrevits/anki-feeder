defmodule AnkiFeeder.Repo do
  use Ecto.Repo,
    otp_app: :anki_feeder,
    adapter: Ecto.Adapters.Postgres
end
