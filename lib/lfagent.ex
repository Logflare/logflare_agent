defmodule LFAgent.Main do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    line_count = File.stream!(state.filename)
      |> Enum.count()
    state = Map.put(state, :line_count, line_count)
    IO.puts("Watching #{state.filename} from line #{state.line_count}...")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    {wc, _} = System.cmd("wc", ["-l", "#{state.filename}"])
    [line_count, _] = String.split(wc)
    line_count = String.to_integer(line_count)
    case line_count > state.line_count do
      true ->
        sed_opt = "#{state.line_count},#{line_count}p"
        {sed, _} = System.cmd("sed", ["-n", "#{sed_opt}", "#{state.filename}"])
        String.split(sed, "\n", trim: true)
          |> Enum.each(fn(line) -> log_line(line) end)
        state = Map.put(state, :line_count, line_count)
        schedule_work()
        {:noreply, state}
      _false ->
        schedule_work()
        {:noreply, state}
    end

    # {logs, _} = System.cmd("tail", ["-n", "15", "./log_examples/large_access.log"])
    # sed '10q;d' Dev/lfagent/log_examples/large_access.log
    # wc -l < Dev/lfagent/log_examples/large_access.log

  end

  defp log_line(line) do
    url = "https://logflare.app/api/logs"
    headers = [
      {"Content-type", "application/json"},
      {"X-API-KEY", "SL7NBVZbxN1C"}
    ]
    body = Jason.encode!(%{
      log_entry: line,
      source: "69dc2c0d-a4c8-4bca-9c32-026968479ca8",
      })
    request = HTTPoison.post!(url, body, headers)
    unless request.status_code == 200 do
      IO.puts("[LOGFLARE] Something went wrong. Logflare reponded with a #{request.status_code} HTTP status code.")
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
