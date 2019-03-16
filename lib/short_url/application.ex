defmodule ShortUrl.Application do
  @moduledoc false

  use Application

  @children [
    ShortUrl,
    ShortUrl.Store.Agent,
    ShortUrl.Store.GenServer
  ]
  @opts [strategy: :one_for_one, name: ShortUrl.Supervisor]

  def start(_type, _args),
    do: Supervisor.start_link(@children, @opts)
end
