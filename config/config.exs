# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :monitor,
  ets_file: "/tmp/stats_collection.tab"

#config :monitor, :settings,
#  environment: Atom.to_string(Mix.env),
#  hostname: "fotografiska-dev"

config :vmstats,
  sink: Monitor.Fluxter,
  base_key: "vmstats_",
  key_seperator: "$", #default
  interval: 10000, # miliseconds
  sched_time: true # default


#config :fluxter,
#  host: "192.168.178.31",
#  port: 8093

#config :fluxter, MyApp.Fluxter,
#  host: "192.168.178.31",
#  port: 8093,
#  pool_size: 10
