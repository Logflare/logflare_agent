# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
config :logger, :console, format: "$time $metadata[$level] $levelpad$message\n"

config :lfagent,
  sources: [
    %{
      path: "/private/var/log/system.log",
      source: "f0b27c3e-cb84-4603-9460-37007fd97cec"
    },
    %{
      path: "/Users/chasegranberry/.cloudflared/cloudflared.log",
      source: "f0b27c3e-cb84-4603-9460-37007fd97cec"
    }
  ],
  url: "https://api.logflare.app",
  api_key: "XXXXXX"

#
# and access this configuration in your application as:
#
#     Application.get_env(:lfagent, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
