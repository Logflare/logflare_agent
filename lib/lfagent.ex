defmodule LFAgent.Main do
  @moduledoc """
  Watches a file and sends new lines to the Logflare API each second.
  """

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: state.id)
  end

  def init(state) do
    line_count = File.stream!(state.filename)
      |> Enum.count()
    state = Map.put(state, :line_count, line_count)
    IO.puts("Watching #{state.filename} from line #{state.line_count} for source #{state.source}...")
    schedule_work()
    {:ok, state}
  end

  @doc """
  Counts lines in the file, compares to previous line count state.
  If new state is greater than old state, get the new lines and send
  them to Logflare.

  We're concerned with the `state.filename` and `state.line_count`.

  If new lines are found we update the `state.line_count` to reflect
  the current state of the log file.

  """

  def handle_info(:work, state) do
    {wc, _} = System.cmd("wc", ["-l", "#{state.filename}"])
    [line_count, _] = String.split(wc)
    line_count = String.to_integer(line_count)
    case line_count > state.line_count do
      true ->
        sed_opt = "#{state.line_count},#{line_count}p"
        {sed, _} = System.cmd("sed", ["-n", "#{sed_opt}", "#{state.filename}"])
        String.split(sed, "\n", trim: true)
          |> Enum.each(fn(line) -> log_line(line, state) end)
        state = Map.put(state, :line_count, line_count)
        schedule_work()
        {:noreply, state}
      false ->
        schedule_work()
        {:noreply, state}
    end

    # {logs, _} = System.cmd("tail", ["-n", "15", "./log_examples/large_access.log"])
    # sed '10q;d' Dev/lfagent/log_examples/large_access.log
    # wc -l < Dev/lfagent/log_examples/large_access.log

  end

  defp log_line(line, state) do
    api_key = System.get_env("LOGFLARE_KEY")
    source = state.source
    url = "https://logflare.app/api/logs"
    user_agent = List.to_string(Application.spec(:lfagent, :vsn))

    headers = [
      {"Content-type", "application/json"},
      {"X-API-KEY", api_key},
      {"User-Agent", "Logflare Agent/#{user_agent}"}
    ]
    body = Jason.encode!(%{
      log_entry: line,
      source: source,
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
