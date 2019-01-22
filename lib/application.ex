defmodule LFAgent.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    log_files = Application.get_env(:lfagent, :sources)

    children =
      Enum.map(
          log_files, fn(k) ->
            source = k.source
            log_file = k.path
            agent_id = String.to_atom(log_file)

            supervisor(LFAgent.Main, [%{filename: log_file, source: source, id: agent_id}], id: agent_id)
          end
        )

    opts = [strategy: :one_for_one, name: LFAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
