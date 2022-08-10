defmodule MineSweeper.Repo do
  use Ecto.Repo,
    otp_app: :mine_sweeper,
    adapter: Ecto.Adapters.Postgres
end
