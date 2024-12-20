import Config

config :iex, default_prompt: "❈"

config :hermes,
  router_entries:
    if(config_env() == :prod,
      do: [
        {?a..?m, :app_alpha@l14},
        {?n..?z, :app_beta@l14}
      ],
      else: [
        {?a..?z, node()}
      ]
    )
