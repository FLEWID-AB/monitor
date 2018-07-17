defmodule Monitor.Fluxter do
  use Fluxter

  @behaviour :vmstats_sink

  def collect(type, name, value, opts \\ [tags: [host: "fotografiska-dev"]]) do
    action_name =  List.last(name)

    {name_, topic} = case name do
      [[[_, _], n, _], _, _, a] -> {n, a}
      [[_, _], n] -> {n, nil}
      [[[_, _], n, _], a] -> {n, a}
    end

    field = topic || "total"
    measurement = "erlvm_" <> List.to_string(name_)

    #write(measurement, opts[:tags], [{field, value}])
  end

  def error do
    Map.get!(%{test: "test"}, :test_two)
  end
end
