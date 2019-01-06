defmodule LFAgent.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    log_file = Application.get_env(:lfagent, :file_to_watch)

    children = [
      supervisor(LFAgent.Main, [%{filename: log_file}])
    ]

    opts = [strategy: :one_for_one, name: LFAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
