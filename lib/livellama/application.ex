defmodule LiveLlama.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveLlamaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveLlama.PubSub},
      # Start Finch
      {Finch, name: LiveLlama.Finch},
      # Start the Endpoint (http/https)
      LiveLlamaWeb.Endpoint
      # Start a worker by calling: LiveLlama.Worker.start_link(arg)
      # {LiveLlama.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveLlama.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveLlamaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
