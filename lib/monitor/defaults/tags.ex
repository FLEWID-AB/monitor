defmodule Monitor.Metric.Tags do

  def defaults do
    [
      environment:  Application.get_env(:monitor, :settings)[:environment],
      application:  Application.get_env(:monitor, :settings)[:application_name]
    ]
  end

  def with_defaults(tags) do
    defaults()
    |> Keyword.merge(tags)
  end
end
