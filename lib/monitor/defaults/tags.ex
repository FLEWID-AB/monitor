defmodule Monitor.Metric.Tags do

  def defaults do
    [
      host: Application.get_env(:monitor, :settings)[:hostname],
      environment:  Application.get_env(:monitor, :settings)[:environment]
    ]
  end

  def with_defaults(tags) do
    defaults()
    |> Keyword.merge(tags)
  end
end
