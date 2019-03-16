defmodule ShortUrl.View do
  @moduledoc """
  This module renders the views for the endpoint.
  """

  import Raxx, only: [set_body: 2, set_header: 3]

  @endpoint Application.get_env(:short_url, :store, "http://localhost:8080/")
  @form """
  <form method="POST" action="#{@endpoint}shorten">
  <div class="container">
  <h1>Shorten URL</h1>
  <p>Enter a long URL to have it shortened.</p>
  <hr>

  <label for="url"><b>URL:&nbsp;</b></label>
  <input type="text" placeholder="Enter URL" name="url" required>

  <button type="submit">Shorten!</button>
  </div>
  </form>
  """

  @reply """
  #{@form}
  <br />
  <p>
  Your new URL!
  </p>
  <p>
  <a href="[url]">[url]</a>
  </p>
  """

  @doc """
  Calling this render function will set the content type and render the form
  """
  def render(response) do
    response
    |> set_header("content-type", "text/html")
    |> set_body(@form)
  end

  @doc """
  Calling this render function will set the content type, render the form, and
  show the new URL in on the page.
  """
  def render(response, url) do
    body = String.replace(@reply, "[url]", url)

    response
    |> set_header("content-type", "text/html")
    |> set_body(body)
  end

  @doc """
  Render an error message. The defualt message is "Error: Bad Request"
  """
  def render_error(response, message \\ "Error: Bad Request") do
    response
    |> set_header("content-type", "text/html")
    |> set_body(message)
  end
end
