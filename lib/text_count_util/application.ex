defmodule TextCountUtil.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # The Counter is a child started via Counter.start_link(0)
      {Registry, keys: :unique, name: TextCountUtil.CounterRegistry},
      {DynamicSupervisor, name: TextCountUtil.CounterDynamicSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TextCountUtil.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
