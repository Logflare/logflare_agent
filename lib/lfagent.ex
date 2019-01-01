defmodule LFAgent.Main do
  @file_to_watch "apache_example.txt"

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    # find_cursor() #open file and find line number maybe?
    # Stream.with_index() get the last thing here and pattern match on the index.
    # https://stackoverflow.com/questions/27781482/elixir-can-i-use-stream-resource-to-progressively-read-a-large-data-file
    # Stream.cycle() maybe?
    {:ok, state} = File.stat(@file_to_watch)
    state = Map.from_struct(state)
    state = Map.put(state, :cursor, 0)
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, file_stat} = File.stat(@file_to_watch)
    new_modified_at = file_stat.mtime
    old_modified_at = state.mtime

    schedule_work()
    case old_modified_at == new_modified_at do
      true ->
        # IO.puts("Not modified")
        {:noreply, state}
      false ->
        stream_stuff(state)
    end
  end

# Inspiration:
# https://elixirforum.com/t/streaming-a-log-text-file/8670/3
# https://fabioyamate.com/2014/08/15/playing-with-elixir-streams-in-iex/

  defp stream_stuff(state) do
    # output = IO.stream(:stdio, :line)
    # IO.puts("+++++++++++")
    # IO.inspect(state.cursor)

    stream = File.stream!(@file_to_watch)
      |> Stream.with_index()
      |> Stream.filter(fn {_, cursor} -> cursor > state.cursor end)
      |> Enum.to_list()

    {_, new_cursor} = List.last(stream)

    {:ok, file_stat} = File.stat(@file_to_watch)
    state = Map.from_struct(file_stat)
    state = Map.put(state, :cursor, new_cursor)

    IO.inspect(stream)

    {:noreply, state}
  end

#  defp set_cursor(state) do
#    stream = File.stream!(@file_to_watch)
#      |> Stream.with_index()
#      |> Enum.to_list()
#
#    {_, cursor} = List.last(stream)
#    Map.put(state, :cursor, cursor)
#
#    {:noreply, state}
#  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5000)
  end

end
