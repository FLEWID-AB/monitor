defmodule Monitor.ExceptionLogger do
  require Logger
  @moduledoc """
  This is based on the Erlang [error_logger](http://erlang.org/doc/man/error_logger.html).
  To set this up, add `:ok = :error_logger.add_report_handler(Monitor.Logger)` to your application's start function. Example:
  ```elixir
  def start(_type, _opts) do
    children = [
      ...
    ]
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    :ok = :error_logger.add_report_handler(Monitor.ExceptionLogger)
    Supervisor.start_link(children, opts)
  end
  ```
  Your application will then be running a event handler that receives error report messages and send them to Sentry.
  It is important to note that the same report handler can be added multiple times.  If you run an umbrella app, and add the report handler in multiple individual applications, the same error will be reported multiple times (one for each handler).  There are two solutions to fix it.
  The first is to ensure that the handler is only added at the primary application entry-point.  This will work, but can be brittle, and will not work for applications running the multiple release style.
  The other solution is to check for existing handlers before trying to add another.  Example:
  ```elixir
  if !(Monitor.ExceptionLogger in :gen_event.which_handlers(:error_logger)) do
    :ok = :error_logger.add_report_handler(Monitor.Logger)
  end
  ```
  With this solution, if a handler is already running, it will not add another.  One can add the code to each application, and there will only ever be one handler created.  This solution is safer, but slightly more complex to manage.
  """

  @behaviour :gen_event

  def init(_mod), do: {:ok, []}

  def handle_call({:configure, new_keys}, _state), do: {:ok, :ok, new_keys}

  def handle_event({:error_report, _gl, {_pid, _type, [message | _]}}, state) when is_list(message) do
    try do
      config = cfg()
      {kind, exception, substack, stack, module} =
        get_exception_and_stacktrace(message[:error_info])
        |> get_initial_call_and_module(message)

      [error|stack_nice] = format_stack(substack)

      fields =
       [{"error", "#{inspect(exception,   limit: :infinity) |> String.replace("\"", "'") |> String.replace("\\n", "")} in #{inspect(module,      limit: :infinity)}"},
        {"trace",     "#{error}<br>#{Enum.join(stack_nice, "<br>")}"}]

      name = Application.get_env(:monitor, :settings)[:exception_series_name] || "exceptions"

      tags = [

      ] |> Monitor.Metric.Tags.with_defaults()


      IO.puts("Sending #{name} to Telegraf #{inspect(fields)}")
      Monitor.Fluxter.write(name, tags, fields)
    rescue
      ex ->
        Logger.warn(fn -> "Unable to notify due to #{inspect(ex)}! #{inspect(message)}" end)
    end

    {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  def handle_info(_msg, state) do
    {:ok, state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  defp get_exception_and_stacktrace({kind, {exception, sub_stack}, stack})
       when is_list(sub_stack) do
    {kind, exception, sub_stack, stack}
  end

  defp get_exception_and_stacktrace({kind, exception, stacktrace}) do
    {kind, exception, stacktrace, []}
  end

  # GenServer exits will usually only report a stacktrace containing core
  # GenServer functions.  This gets the `:initial_call` to help disambiguate, as it contains
  # the MFA for how the GenServer was started.
  defp get_initial_call_and_module({kind, exception, substack, stack}, error_info) do
    case Keyword.get(error_info, :initial_call) do
      {module, function, arg} ->
        {kind, exception, substack ++ [{module, function, arg, []}], stack, module}

      _ ->
        {kind, exception, substack, stack, nil}
    end
  end

  defp format_stack(stack) do
    [first|substack] = stack
    [stack_first_line(first)] ++ stack_normal(substack)
  end

  defp stack_first_line(line) do
    {module, function, params, file_info} = line
    #str_params = Enum.join(params, ", ")
    case file_info do
      [file: file, line: line] ->
        "Error in #{module}->#{function} in #{file}, line: #{line}<br>params: #{inspect(params)}"
      _ ->
        "Error in #{module}->#{function}<br>params: #{inspect(params)}"
    end
  end

  defp stack_normal(stack) do
    stack_nice = Enum.map(stack, fn({module, function, params, file_info}) ->
      #{:erl_eval, :do_apply, 6, [file: 'erl_eval.erl', line: 668]}
      case file_info do
        [file: file, line: line] ->
          "#{module}->#{function} in #{file}, line: #{line}"
        _ ->
          "#{module}->#{function}"
      end
    end)
  end

  defp cfg do
    Application.get_env(:monitor, :settings)
  end
end
