defmodule LFAgentTest do
  use ExUnit.Case
  doctest LFAgent

  test "greets the world" do
    assert LFAgent.hello() == :world
  end
end
