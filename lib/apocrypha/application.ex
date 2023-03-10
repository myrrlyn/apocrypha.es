defmodule Apocrypha.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ApocryphaWeb.Telemetry,
      # Start the Ecto repository
      Apocrypha.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Apocrypha.PubSub},
      {Apocrypha.Library, %{}},
      # Start the Endpoint (http/https)
      ApocryphaWeb.Endpoint
      # Start a worker by calling: Apocrypha.Worker.start_link(arg)
      # {Apocrypha.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apocrypha.Supervisor]
    out = Supervisor.start_link(children, opts)

    case out do
      {:ok, _pid} -> Apocrypha.Library.build_index()
        _ -> nil
    end
    Logger.notice("boot complete")

    out
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ApocryphaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
