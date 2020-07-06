# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :phoenix_distillery, PhoenixDistilleryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LZzAPGGyoYCYKwgradoAHaX3v9YmbjeWk9OipVnLIADf0a7lKMN6W3A3gkJmrqb8",
  render_errors: [view: PhoenixDistilleryWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixDistillery.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_distillery,
  from_file: "hello!",
  from_dynamic_env: System.get_env("COOL_CONFIG", "config not found"),
  from_regular_env: System.get_env("COOL_CONFIG", "config not found")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
