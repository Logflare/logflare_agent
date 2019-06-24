defmodule LogflareAgentTest do
  use ExUnit.Case
  doctest LogflareAgent

  test "greets the world" do
    assert LogflareAgent.hello() == :world
  end
end
