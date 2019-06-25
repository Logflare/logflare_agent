defmodule LogflareAgentTest do
  use ExUnit.Case

  test "count lines works file does not exist" do
    assert LogflareAgent.Main.count_lines("/some_path/does_not_exist.log") == 1
  end
end
