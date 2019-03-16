defmodule ShortUrl do
  @moduledoc """
  Documentation for ShortUrl.
  """
  use Ace.HTTP.Service, port: 8080, cleartext: true
  use Raxx.SimpleServer

  import ShortUrl.View
  import ShortUrl.RouteHelper

  @doc """
  Root path. It renders the form to submit a URL
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _state) do
    :ok
    |> response()
    |> render()
  end

  @doc """
  Request handler to redirect to the real URL
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: [path]}, _state) do
    redirect_to_path(path)
  end

  @doc """
  Request to shorten a URL.
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["shorten"], body: body}, _state) do
    with %{"url" => uri} <- URI.decode_query(body),
         {:ok, uri} <- validate_uri(uri),
         {:ok, uri} <- commit_uri(uri) do
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

  @doc """
  Request to shorten a URL. If no body is provided the response is an error message.
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["shorten"]}, _state) do
    :bad_request
    |> response()
    |> render_error()
  end

  @doc """
  Damn favicon route
  """
  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, raw_path: "/favicon.ico"}, _state) do
    response(:ok)
  end
end
