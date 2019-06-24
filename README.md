# LFAgent

## About

This Elixir app watches a file and sends new lines to Logflare via the API.

## Usage

To install stand alone:

  * Install Erlang
  * Install Elixir
  * `git clone https://github.com/Logflare/logflare-agent.git`
  * `mix deps.get`

Configure it.

`mix release`

`_build/dev/rel/lfagent/bin/lfagent start`

Optionally to start the agent at bootup:

`crontab -e`

Add this line to your crontab and save:

`@reboot /FULL_PATH_TO_INSTALL/_build/dev/rel/lfagent/bin/lfagent start`

## Configure

Change the file to watch and the source key in `./config/config.exs`

```elixir
config :lfagent,
  sources: [
    %{
      path: "/home/logflare/app_release/logflare/var/log/erlang.log.1",
      source: "SOURCE_ID"
    },
    %{
      path: "/home/logflare/app_release/logflare/var/log/erlang.log.2",
      source: "SOURCE_ID"
    },
    %{
      path: "/home/logflare/app_release/logflare/var/log/erlang.log.3",
      source: "SOURCE_ID"
    },
    %{
      path: "/home/logflare/app_release/logflare/var/log/erlang.log.4",
      source: "SOURCE_ID"
    },
    %{
      path: "/home/logflare/app_release/logflare/var/log/erlang.log.5",
      source: "SOURCE_ID"
    }
  ],
  url: "https://api.logflare.app",
  api_key: "YOUR_API_KEY"
```

Your `source`s can be different with each file. This example is useful when watching Erlang log files.

## Installation with Hex

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lfagent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lfagent, "~> 0.5.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lfagent](https://hexdocs.pm/lfagent).
