# Phoenix Phrenzy Tetris LiveView.

# Initializing

Before we can run the app we need to download all the dependencies.

First, let's install Elixir and Erlang. To automate this there is `.tool-versions` [asfd](https://github.com/asdf-vm/asdf) config file that lists versions of the tools we use to build our project. If you have `asdf` installed you can just run

```
asdf install
```

from the root of the project. Afterwards, check that you have correct Elixir version:

```
> elixir --version
Erlang/OTP 22 [erts-10.7] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Elixir 1.10.2 (compiled with Erlang/OTP 21)
```

Next we need to install the application dependencies:

```
mix deps.get
```

Make sure we can successfully compile all the dependencies:

```
mix deps.compile
```

If all went well, we are now ready to run our application.

# Running

We can un the application with the following command:

```
> iex -S mix phx.server
```

you should be able to access the application at http://localhost:4000

# Development

### Code Coverage

We are using [`excoveralls`](https://hex.pm/packages/excoveralls) package.

It is recommended t oplace coveralls.json into each of the umbrella apps' root. A starter sample looks like this:

```
{
  "coverage_options": {
    "treat_no_relevant_lines_as_covered": true,
    "output_dir": "cover"
  }
}
```

### Code Style/Linting

To maintain consistent style and to help us follow Elixir community source code best practices we are using [`credo`](https://hex.pm/packages/credo).

### Umbrella Applications

* [tetris] in ./apps/tetris - core game engine
* [tetris_web] in ./apps/tetris_web - web UI with LiveView
