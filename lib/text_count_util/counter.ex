defmodule TextCountUtil.Counter do
  use GenServer

  alias TextCountUtil.{CounterDynamicSupervisor, CounterRegistry}

  def start_link(line_number) do
    name = {:via, Registry, {CounterRegistry, line_number}}
    DynamicSupervisor.start_child(
      CounterDynamicSupervisor,
      %{
        id: GenServer,
        start: {
          GenServer,
          :start_link,
          [__MODULE__, 0, [name: name]]
        },
        restart: :transient
      }
    )
  end

  ## Callbacks

  @impl GenServer
  def init(_), do: {:ok, 0}

  @impl GenServer
  def handle_call(:get_count, _from, count) do
    {:stop, :normal, count, count}
  end

  @impl GenServer
  def handle_cast({:do_count, line}, _state) do
    {:noreply, Enum.count(String.split(line, " "))}
  end
end