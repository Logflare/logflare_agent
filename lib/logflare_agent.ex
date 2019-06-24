defmodule LogflareAgent.Main do
  @moduledoc """
  Watches a file and sends new lines to the Logflare API each second.
  """
  require Logger

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: state.id)
  end

  def init(state) do
    schedule_work()

    line_count = count_lines(state.filename)
    state = Map.put(state, :line_count, line_count)

    Logger.info(
      "[Logflare Agent] Watching #{state.filename} from line #{state.line_count} for source #{
        state.source
      }..."
    )

    log_line(
      "[Logflare Agent] Watching #{state.filename} from line #{state.line_count} for source #{
        state.source
      }...",
      state
    )

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
    line_count = count_lines(state.filename)

    case line_count > state.line_count do
      true ->
        sed_opt = "#{state.line_count},#{line_count}p"
        {sed, _} = System.cmd("sed", ["-n", "#{sed_opt}", "#{state.filename}"])

        sed
        |> String.split("\n", trim: true)
        |> Enum.drop(1)
        |> Enum.each(fn line -> log_line(line, state) end)

        state = Map.put(state, :line_count, line_count)
        schedule_work()
        {:noreply, state}

      false ->
        state = Map.put(state, :line_count, line_count)
        schedule_work()
        {:noreply, state}
    end
  end

  defp log_line(line, state) do
    api_key = Application.get_env(:logflare_agent, :api_key)
    source = state.source
    url = Application.get_env(:logflare_agent, :url) <> "/logs"
    user_agent = List.to_string(Application.spec(:logflare_agent, :vsn))

    headers = [
      {"Content-type", "application/json"},
      {"X-API-KEY", api_key},
      {"User-Agent", "Logflare Agent/#{user_agent}"}
    ]

    body =
      Jason.encode!(%{
        log_entry: line,
        source: source
      })

    request = HTTPoison.post!(url, body, headers)

    unless request.status_code == 200 do
      Logger.error(
        "[Logflare Agent] Something went wrong. Logflare reponded with a #{request.status_code} HTTP status code."
      )
    end
  end

  defp count_lines(filename) do
    {wc, exit_status} = System.cmd("wc", ["-l", "#{filename}"], stderr_to_stdout: true)

    if exit_status == 1 do
      1
    else
      [line_count, _] = String.split(wc)
      String.to_integer(line_count)
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
