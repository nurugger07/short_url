defmodule ShortUrl do
  @moduledoc """
  Documentation for ShortUrl.
  """
  use Ace.HTTP.Service, port: 8080, cleartext: true
  use Raxx.SimpleServer

  import ShortUrl.View

  @store Application.get_env(:short_url, :store, ShortUrl.Store.Agent)
  @endpoint Application.get_env(:short_url, :store, "http://localhost:8080/")

  @doc """
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _state) do
    :ok
    |> response()
    |> render()
  end

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: [path]}, _state) do
    redirect_to_path(path)
  end

  @doc """
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["shorten"], body: body}, _state) do
    with %{"url" => uri} <- URI.decode_query(body),
         {:ok, uri} <- validate_uri(uri),
         {:ok, uri} <- generate_uri(uri) do

      :created
      |> response()
      |> render(uri)
    else
      _error ->
        :bad_request
        |> response()
        |> render_error()
    end
  end

  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["shorten"]}, _state) do
    :bad_request
    |> response()
    |> render_error()
  end

  @doc """
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, raw_path: "/favicon.ico"}, _state) do
    response(:ok)
  end

  defp validate_uri(uri) do
    with %URI{authority: nil, scheme: nil} <- URI.parse(uri) do
      {:error, :invalid_uri}
    else
      _uri ->
        {:ok, uri}
    end
  end

  defp redirect_to_path(path) do
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

  defp generate_uri(uri) do
    {:ok, key} = @store.commit(uri)
    {:ok, @endpoint <> key}
  end
end
