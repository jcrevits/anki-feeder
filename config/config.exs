# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :anki_feeder,
  ecto_repos: [AnkiFeeder.Repo]

# Configures the endpoint
config :anki_feeder, AnkiFeederWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2SfI8TnoJwitRYu5uGbVFxFAo/zqH0r5fM8+d1RayWG5r+hpQmXHcx0EiXhdh9gQ",
  render_errors: [view: AnkiFeederWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AnkiFeeder.PubSub,
  live_view: [signing_salt: "RbUryBd8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
