import Config

config :iex, default_prompt: "❈"

config :hermes,
  router_entries: [
    {?a..?z, node()}
  ]
