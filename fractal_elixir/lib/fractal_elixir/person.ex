defmodule FractalElixir.Person do
  alias FractalElixir.{Client, People}
  use GenServer

  def new(name, client_name) do
    client = %Client{name: client_name}
    child_spec = %{
      id: name,
      start: {__MODULE__, :start_link, [name, client]}
    }
    DynamicSupervisor.start_child(People, child_spec)
  end

  def start_link(name, client) do
    GenServer.start_link(__MODULE__, %{client: client, name: name, timer: nil, position: nil})
  end

  @impl true
  def init(state) do
    timer = next_tick()
    {:ok, %{state | timer: timer, position: :sitting}}
  end

  @impl true
  def handle_info(:act, %{position: :sitting} = state) do
    IO.puts "#{state.name} stands up"
    timer = next_tick()
    {:noreply, %{state | position: :standing, timer: timer}}
  end

  @impl true
  def handle_info(:act, state) do
    action = Enum.random(0..1)
    new_state = case action do
      0 ->
        IO.puts "#{state.name} starts walking"
        timer = next_tick()
        %{state | position: :walking, timer: timer}
      _ ->
        IO.puts "#{state.name} sits down"
        timer = next_tick()
        %{state | position: :sitting, timer: timer}
    end
    {:noreply, new_state}
  end

  def next_tick(delay \\ :timer.seconds(5)) do
    Process.send_after(self(), :act, delay)
  end
end
