defmodule ShortUrl.Store.GenServer do
  @moduledoc """

  """
  use GenServer

  import ShortUrl.Store.Helper

  @behaviour ShortUrl.Store

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    {:ok, []}
  end

  @doc """
  The commit function stores the URI in the Process with a generated key that
  is used to retrieve the URI.
  """
  @impl ShortUrl.Store
  def commit(uri) do
    GenServer.call(__MODULE__, {:commit, uri})
  end

  @doc """
  The lookup function retrievess the URI from the process using a supplied key
  """
  @impl ShortUrl.Store
  def lookup(key) do
    GenServer.call(__MODULE__, {:lookup, key})
  end

  @doc """
  This handles the `:commit` message to the process
  """
  @impl true
  def handle_call({:commit, uri}, _from, state) do
    key = generate_key()

    with new_state when is_list(new_state) <- handle_commit(state, uri, key) do
      {:reply, {:ok, key}, new_state}
    else
      error ->
        {:reply, {:error, error}, state}
    end
  end

  @doc """
  This handles the `:lookup` message to the process
  """
  @impl true
  def handle_call({:lookup, key}, _from, state) do
    {:reply, handle_lookup(state, key), state}
  end
end
