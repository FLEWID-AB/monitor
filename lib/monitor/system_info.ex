defmodule Monitor.SystemInfo do
  def collect_info do
    info = :erlang.system_info(:info)
          |> String.split("=")
          |> Enum.reject(fn(x) -> x == "" or is_nil(x) end)
          |> Enum.map(fn(i) -> String.split(i, "\n") end)
          |> Enum.map(fn(row) ->
            [category|values] = row
            options = Enum.map(values, fn(v) ->
              [option|value] = String.split(v, ":") |> Enum.map(fn(t) -> String.trim(t) end)
              {option, List.first(value)}
            end) |> Enum.reject(fn({key, val}) -> key == "" or is_nil(key) end) |> Enum.into(%{})
            {category, options}
          end)
          |> Enum.into(%{})
  end

  def collect_memory do
    :erlang.memory
  end
end
