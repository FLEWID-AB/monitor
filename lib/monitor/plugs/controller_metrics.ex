defmodule Monitor.Plug.ControllerMetrics do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  @unit         Application.get_env(:monitor, :plug)[:unit]                   || :milli_seconds
  @metric_name  Application.get_env(:monitor, :plug)[:controller_series_name] || "request_metrics"

  def init(opts), do: opts
  def call(conn, _config) do
    # Here we start the timer for this one request.
    req_start_time = :erlang.monotonic_time(@unit)

    Plug.Conn.register_before_send(conn, fn conn ->
      # This will run right before sending the HTTP response
      # giving us a pretty good measurement of how long it took
      # to generate the response.
      request_duration =
        :erlang.monotonic_time(@unit) - req_start_time

      # hand off task for metric collection
      Task.start(fn -> __MODULE__.write_metric(conn, request_duration) end)
      # continue on your way
      conn
    end)
  end

  # Build the metric name based on the controller name and action
  defp get_tags(conn) do
    [
      controller:   Phoenix.Controller.controller_module(conn),
      action:       Phoenix.Controller.action_name(conn)
    ]
    |> Monitor.Metric.Tags.with_defaults()

  end

  defp get_fields(conn, duration) do
    [
      {"duration", duration},
      {"code", conn.status},
      {"method", conn.method}
    ]
  end

  def write_metric(conn, duration) do
    # check if the controller should be ignored
    if allow_write?(conn) do
      tags    = conn |> get_tags
      fields  = conn |> get_fields(duration)

      #IO.puts("\n\nTAGS: #{inspect(tags)}\nFIELDS: #{inspect(fields)}\nNAME: #{inspect(@metric_name)}\n\n")
      # write metric measurement
      Monitor.Fluxter.write(@metric_name, tags, fields)
    end
  end

  def allow_write?(conn) do
    if can_trace_controller?(conn) and can_trace_action?(conn) do
      true
    else
      false
    end
  end

  defp can_trace_controller?(conn) do
    ignore_controller = Application.get_env(:monitor, :plug)[:ignore_controllers] || []
    controller_name = Phoenix.Controller.controller_module(conn)
    ignore =
      if length(ignore_controller) > 0 do
        Enum.any?(ignore_controller, fn({controller, opts}) ->
          if ( controller_name == controller ) do

              action_name = Phoenix.Controller.action_name(conn)
              cond do
                Keyword.has_key?(opts, :except) and not action_name in opts[:except] -> true
                Keyword.has_key?(opts, :only) and action_name in opts[:only] -> true
                not Keyword.has_key?(opts, :only) and not Keyword.has_key?(opts, :except) -> true
                true -> false
              end
          else
            false
          end
        end)
     end

     if ignore do
       false
     else
       true
     end
  end

  defp can_trace_action?(conn) do
    ignore_actions = Application.get_env(:monitor, :plug)[:ignore_actions] || []
    action_name = Phoenix.Controller.action_name(conn)
    if action_name in ignore_actions do
      false
    else
      true
    end
  end

  defp cfg do
    Application.get_env(:monitor, :plug)
  end
end
