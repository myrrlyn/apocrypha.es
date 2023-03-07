defmodule Apocrypha.Repo do
  use Ecto.Repo,
    otp_app: :apocrypha,
    adapter: Ecto.Adapters.SQLite3
end
