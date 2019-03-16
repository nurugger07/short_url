defmodule ShortUrl.RouteHelper do
  @moduledoc """
  Just some helpers for the routes
  """

  import ShortUrl.View
  import Raxx, only: [response: 1, redirect: 1]

  @store Application.get_env(:short_url, :store, ShortUrl.Store.GenServer)
  @endpoint Application.get_env(:short_url, :store, "http://localhost:8080/")

  @doc """
  Validate the URI. Not a perfect test but it's enough for this.
  """
  def validate_uri(uri) do
    with %URI{authority: nil, scheme: nil} <- URI.parse(uri) do
      {:error, :invalid_uri}
    else
      _uri ->
        {:ok, uri}
    end
  end

  @doc """
  Look up a key in the store. If a URI is found then redirect to it. If
  not then return an error.
  """
  def redirect_to_path(path) do
    with {:ok, uri} <- @store.lookup(path) do
      redirect(uri)
    else
      {:error, :not_found} ->
        :not_found
        |> response()
        |> render_error("Error: No matching URI")

      {:error, :invalid_argument} ->
        :bad_request
        |> response()
        |> render_error()
    end
  end

  @doc """
  Commit the URI to the data store and return the short URI.
  """
  def commit_uri(uri) do
    {:ok, key} = @store.commit(uri)
    {:ok, @endpoint <> key}
  end
end
