import Config

config :iex, default_prompt: "❈"

config :hermes,
  routing_table: [
    {?a..?z, node()}
  ]
