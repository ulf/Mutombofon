# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mutombofon,
  ecto_repos: [Mutombofon.Repo]

# Configures the endpoint
config :mutombofon, Mutombofon.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xz8FwJ2mIVD/dZfA3D19QC7ckHRY3piGMDeSqWxJe81C/05J4i7OSyUSdFbTAmau",
  render_errors: [view: Mutombofon.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mutombofon.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mutombofon, Mutombofon.Scheduler,
  jobs: [
    # Every minute
    {"* * * * *",      {Mutombofon.FileChecker, :run, []}},
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
