use Mix.Config

config :logger,
backends: [{LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "log/error.log",
  level: :error,
  format: "$time [$level] $message\n"
