use Mix.Config

config :phoenix_distillery, :from_dynamic_env, System.get_env("COOL_CONFIG", "config not found")
