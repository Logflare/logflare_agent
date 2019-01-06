defmodule LFAgent.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    log_file = Application.get_env(:lfagent, :file_to_watch)
    agent_id = String.to_atom(log_file)

    children = [
      supervisor(LFAgent.Main, [%{filename: log_file, id: agent_id}], id: agent_id)
      # figure out how to dynamically build children list to support
      # multple files
    ]

    opts = [strategy: :one_for_one, name: LFAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
