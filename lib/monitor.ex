defmodule Monitor do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      Monitor.Fluxter.child_spec([])
    ]



    {:ok, pid} = Supervisor.start_link(children, [strategy: :one_for_one, name: Monitor.Supervisor])

    #if !(Monitor.ExceptionLogger in :gen_event.which_handlers(:error_logger)) do
      :ok = :error_logger.add_report_handler(Monitor.ExceptionLogger)
    #end
    if(Application.get_env(:monitor, :enabled)) do
      vm_stats = Application.start(:vmstats)
      IO.puts("### Starting VMSTATS: #{inspect(vm_stats)}###")
    end

    {:ok, pid}
  end
end
