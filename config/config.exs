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

config :logflare_agent,
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
  api_key: "XXXXX"
