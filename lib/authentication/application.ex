defmodule Authentication.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthenticationWeb.Telemetry,
      Authentication.Repo,
      {DNSCluster, query: Application.get_env(:authentication, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Authentication.PubSub},
      # Start a worker by calling: Authentication.Worker.start_link(arg)
      # {Authentication.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthenticationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Authentication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthenticationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
