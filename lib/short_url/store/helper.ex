defmodule ShortUrl.Store.Helper do
  @moduledoc """
  This module is a set of functions that are shared between the stores. It is not
  intented to be used outside the scope of the stores as many of the functions
  make assumptions about how the data is structured.
  """

  @doc """
  Generate a random and unique string key for the short URI
  """
  @spec generate_key() :: String.t()
  def generate_key do
    UUID.uuid4()
    |> String.split("-")
    |> hd()
  end

  @doc """
  Given a single tuple in a list this function extracts the url to return.

  ## Example
    iex> ShortUrl.Store.Helper.return_uri([])
    {:error, :not_found}
    iex> ShortUrl.Store.Helper.return_uri([{"key", "URI"}])
    {:ok, "URI"}

  """
  @spec return_uri(List.t()) ::
          {:ok, String.t()} | {:error, :not_found} | {:error, :invalid_argument}
  def return_uri([]), do: {:error, :not_found}
  def return_uri([{_key, uri}]), do: {:ok, uri}
  def return_uri(list) when is_list(list), do: {:error, :invalid_argument}

  @doc """
  Given a 2 element tuple with `{key, uri}` and a key this function
  will try to determine if the key in the tuple matches the second
  arguement.

  ## Example
    iex> ShortUrl.Store.Helper.has_key?({"key", "URI"}, "key")
    true
    iex> ShortUrl.Store.Helper.has_key?({"key", "URI"}, "no-key")
    false

  """
  @spec has_key?(Tuple.t(), String.t()) :: Boolean.t()
  def has_key?({stored, _}, new) when stored == new, do: true
  def has_key?(_, _), do: false

  @doc """
  Given a 2 element tuple with `{key, uri}` and a uri this function
  will try to determine if the URI in the tuple matches the second
  arguement.

  ## Example
    iex> ShortUrl.Store.Helper.has_uri?({"key", "URI"}, "URI")
    true
    iex> ShortUrl.Store.Helper.has_uri?({"key", "URI"}, "no-URI")
    false
  """
  @spec has_uri?(Tuple.t(), String.t()) :: Boolean.t()
  def has_uri?({_, stored}, new) when stored == new, do: true
  def has_uri?(_, _), do: false

  @doc """
  Given a list this function will commit the URI and key to the list. If the URI is
  already in the list it will not modify the list.

  ## Examples
    iex> ShortUrl.Store.Helper.handle_commit([], "uri", "key")
    {"key",[{"key", "uri"}]}
    iex> ShortUrl.Store.Helper.handle_commit([{"key1", "uri1"}], "uri2", "key2")
    {"key2", [{"key2", "uri2"}, {"key1", "uri1"}]}
    iex> ShortUrl.Store.Helper.handle_commit([{"key", "uri"}], "uri", "new-key")
    {"key", [{"key", "uri"}]}

  """
  @spec handle_commit(List.t(), String.t(), String.t()) :: {String.t(), List.t()}
  def handle_commit([], uri, key), do: {key, [{key, uri}]}

  def handle_commit(state, uri, key) when is_list(state) do
    with [{key, ^uri}] <- Stream.filter(state, &has_uri?(&1, uri)) |> Enum.to_list() do
      {key, state}
    else
      [] ->
        {key, [{key, uri} | state]}
    end
  end

  @doc """
  Given a list of tuples this function will look for a matching key and
  return the URI

  ## Examples
    iex> ShortUrl.Store.Helper.handle_lookup([{"key", "URI"}], "key")
    {:ok, "URI"}
    iex> ShortUrl.Store.Helper.handle_lookup([{"key", "URI"}], "no-key")
    {:error, :not_found}
    iex> ShortUrl.Store.Helper.handle_lookup([{"key", "URI1"}, {"key", "URI2"}], "key")
    {:error, :invalid_argument}

  """
  @spec handle_lookup(List.t(), String.t()) ::
          {:ok, String.t()} | {:error, :invalid_argument} | {:error, :not_found}
  def handle_lookup([], _key), do: {:error, :not_found}

  def handle_lookup(state, key) when is_list(state) do
    state
    |> Stream.filter(&has_key?(&1, key))
    |> Enum.to_list()
    |> return_uri()
  end
end
