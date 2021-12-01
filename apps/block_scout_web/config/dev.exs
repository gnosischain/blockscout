use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.

port =
  case System.get_env("PORT") && Integer.parse(System.get_env("PORT")) do
    {port, _} -> port
    :error -> nil
    nil -> nil
  end

config :block_scout_web, BlockScoutWeb.Endpoint,
  secret_key_base:
    System.get_env("SECRET_KEY_BASE") || "RMgI4C1HSkxsEjdhtGMfwAHfyT6CKWXOgzCboJflfSm4jeAlic52io05KB6mqzc5",
  http: [
    port: port || 4000,
    protocol_options: [idle_timeout: 300_000]
  ],
  url: [
    scheme: "http",
    host: System.get_env("BLOCKSCOUT_HOST") || "localhost",
    path: System.get_env("NETWORK_PATH") || "/",
    api_path: System.get_env("API_PATH") || "/"
  ],
  https: [
    port: (port && port + 1) || 4001,
    cipher_suite: :strong,
    certfile: System.get_env("CERTFILE") || "priv/cert/selfsigned.pem",
    keyfile: System.get_env("KEYFILE") || "priv/cert/selfsigned_key.pem"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :block_scout_web, BlockScoutWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/block_scout_web/views/.*(ex)$},
      ~r{lib/block_scout_web/templates/.*(eex)$}
    ]
  ]

config :block_scout_web, BlockScoutWeb.Tracer, env: "dev", disabled?: true

config :logger, :block_scout_web,
  level: :debug,
  path: Path.absname("logs/dev/block_scout_web.log")

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
