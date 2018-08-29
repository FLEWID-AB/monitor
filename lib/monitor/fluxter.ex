defmodule Monitor.Fluxter do
  use Fluxter

  @behaviour :vmstats_sink

  def collect(type, name, value, opts \\ []) do
    config = cfg()

    {name_, topic} = case name do
      [[[_, _], n, _], _, _, a] -> {n, a}
      [[_, _], n] -> {n, nil}
      [[[_, _], n, _], a] -> {n, a}
    end

    field = topic || "total"
    measurement = "erlvm_" <> List.to_string(name_)

    write(measurement, [host: config[:hostname], environment: config[:environment]], [{field, value}])
  end

  def error do
    Map.get!(%{test: "test"}, :test_two)
  end

  defp cfg do
    Application.get_env(:monitor, :settings)
  end
end
