defmodule LFAgent do
  @moduledoc """
  Documentation for LFAgent.
  """

  @doc """
  Hello world.

  ## Examples

      iex> LFAgent.hello()
      :world

  """
  def hello do
    :world
  end

  def streamstuff(filename) do
    output = IO.stream(:stdio, :line)

    File.stream!(filename)
      |> Stream.into(output)
      |> Stream.run()   
  end
end
