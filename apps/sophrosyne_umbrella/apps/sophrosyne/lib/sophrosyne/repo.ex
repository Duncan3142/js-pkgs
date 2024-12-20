defmodule Sophrosyne.Repo do
  use Ecto.Repo,
    otp_app: :sophrosyne,
    adapter: Ecto.Adapters.Postgres
end
