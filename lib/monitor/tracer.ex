defmodule Monitor.Tracer do

  def trace(action, f, opts \\ []) do
    started_at = System.monotonic_time(:microseconds)
    res=f.()
    ended_at = System.monotonic_time(:microseconds)

    # hand off trace handling
    Task.start(fn -> handle_trace(action, started_at, ended_at, res, opts) end)
    # return original result
    res
  end

  defp handle_trace(action, started_at, ended_at, res, opts) do
    duration_in_ms = (ended_at-started_at)/1000

    status = case res do
      {:reply, {:ok, _}, _socket} -> :ok
      {:reply, {:error, _}, _socket} -> :error
      {:ok, _} -> :ok
      {:error, _} -> :error
      _ -> :unknown
    end |> Atom.to_string()

    build_trace(action, status, duration_in_ms, opts)
    |> send_trace()
  end

  defp __sanitize_trace(trace) do
    Enum.filter(trace, fn(trace_entry) ->
      case trace_entry do
        {Process,_,_,_}    -> false
        {__MODULE__,_,_,_} -> false
        _ -> true
      end
    end)
  end

  defp build_trace(action, status, duration, opts) do
    table = opts[:table] || Application.get_env(:monitor, :default_trace_table)

    tags = Monitor.Metric.Tags.with_defaults([action: action])
    if Keyword.has_key?(opts, :tags), do: tags = Keyword.merge(tags, opts[:tags])

    fields = [
      {"duration", duration},
      {"status", status}
    ]

    {table, tags, fields}
  end

  defp send_trace({table, tags, fields}) do
    Monitor.Fluxter.write(table, tags, fields)
  end

end
