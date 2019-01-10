# LFAgent

## About

This Elixir app watches a file and sends new lines to Logflare via the API.

## Usage

To install:

  * Install Erlang
  * Install Elixir
  * `git clone https://github.com/Logflare/logflare-agent.git`
  * `mix deps.get`

Change the file to watch and the source key in `./config/config.exs`

```elixir
config :lfagent,
  file_to_watch: "/private/var/log/system.log",
  source: "YOUR_SOURCE_KEY"
```

`mix release`

`LOGFLARE_KEY=YOUR_API_KEY _build/dev/rel/lfagent/bin/lfagent start`

Optionally to start the agent at bootup:

`crontab -e`

Add this line to your crontab and save:

`@reboot LOGFLARE_KEY=YOUR_API_KEY /FULL_PATH_TO_INSTALL/_build/dev/rel/lfagent/bin/lfagent start`

## Installation

**TODO: figure out how this would work within another app**

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lfagent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lfagent, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lfagent](https://hexdocs.pm/lfagent).
