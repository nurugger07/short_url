defmodule ShortUrl.Store.Agent do
  @moduledoc """

  """
  use Agent

  import ShortUrl.Store.Helper

  alias ShortUrl.Store.Helper

  @behaviour ShortUrl.Store

  def start_link(_) do
    Agent.start_link(fn ->  [] end, name: __MODULE__)
  end

  @doc """
  The commit function stores the URI in the Agent with a generated key that
  is used to retrieve the URI.
  """
  @impl ShortUrl.Store
  def commit(uri) do
    key = generate_key()

    {Agent.update(__MODULE__, Helper, :handle_commit, [uri, key]), key}
  end

  @doc """
  The lookup function retrievess the URI from the Agent using a supplied key
  """
  @impl ShortUrl.Store
  def lookup(key) do
    __MODULE__
    |> Agent.get(&(&1))
    |> handle_lookup(key)
  end
end
