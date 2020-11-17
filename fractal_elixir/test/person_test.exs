defmodule PersonTest do
  use ExUnit.Case

  alias FractalElixir.Person

  test "sends message to act after a given delay" do
    Person.next_tick(80)
    assert_receive :act, 100
  end

  # :sys.get_state should only be used for debugging
  test "has a timer" do
    {:ok, liam} = Person.new("Liam", "Client")
    state = :sys.get_state(liam)
    assert state.timer
  end

  test "starts out sitting" do
    {:ok, liam} = Person.new("Liam", "Client")
    state = :sys.get_state(liam)
    assert state.position == :sitting
  end
end
