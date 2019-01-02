defmodule LFAgent.Main do
  @file_to_watch "apache_example.txt"

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    state = set_cursor(0)
    schedule_work()
    IO.inspect(state)
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, file_stat} = File.stat(@file_to_watch)
    new_modified_at = file_stat.mtime
    old_modified_at = state.mtime

    schedule_work()
    case old_modified_at == new_modified_at do
      true ->
        {:noreply, state}
      false ->
        stream_stuff(state)
    end
  end

  defp stream_stuff(state) do
    stream = File.stream!(@file_to_watch)
      |> Stream.with_index()
      |> Stream.filter(fn {_, cursor} -> cursor > state.cursor end)
      |> Enum.to_list()
    {_, new_cursor} = List.last(stream)
    state = set_cursor(new_cursor)
    IO.inspect(stream)
    {:noreply, state}
  end

  defp set_cursor(cursor) do
    {:ok, file_stat} = File.stat(@file_to_watch)
    state = Map.from_struct(file_stat)
    case cursor == 0 do
      true ->
        stream = File.stream!(@file_to_watch)
          |> Stream.with_index()
          |> Enum.to_list()
        {_, cursor} = List.last(stream)
        Map.put(state, :cursor, cursor)
      false ->
        Map.put(state, :cursor, cursor)
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 500)
  end

end

# https://stackoverflow.com/questions/27781482/elixir-can-i-use-stream-resource-to-progressively-read-a-large-data-file
# Stream.cycle() maybe?

# Inspiration:
# https://elixirforum.com/t/streaming-a-log-text-file/8670/3
# https://fabioyamate.com/2014/08/15/playing-with-elixir-streams-in-iex/
