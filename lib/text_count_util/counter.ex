defmodule TextCountUtil.Counter do
  use GenServer

  alias TextCountUtil.{CounterDynamicSupervisor, CounterRegistry}

  def start_link(line) do
    name = {:via, Registry, {CounterRegistry, ''}}
    DynamicSupervisor.start_child(
      CounterDynamicSupervisor,
      %{
        id: GenServer,
        start: {
          GenServer,
          :start_link,
          [__MODULE__, line, [name: name]]
        },
        restart: :transient
      }
    )
  end

  ## Callbacks

  @impl GenServer
  def init(line), do: {:ok, 0, {:continue, {:count, line}}}

  @impl GenServer
  def handle_call(:get_count, _from, count) do
    {:stop, :normal, count, count}
  end

  @impl GenServer
  def handle_continue({:count, line}, 0) do
    {:noreply, Enum.count(String.split(line, " "))}
  end

  # @impl GenServer
  # def handle_cast({:do_count, line}, _state) do
  #   {:noreply, Enum.count(String.split(line, " "))}
  # end
end