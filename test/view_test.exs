defmodule ShortUrl.ViewTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, %{response: Raxx.response(:ok)}}
  end

  test "`render/1` returns a html form to submit the URI", %{response: response} do
    assert response = %Raxx.Response{} = ShortUrl.View.render(response)
    assert [{"content-type", "text/html"} | _] = response.headers
    assert response.body =~ "Shorten URL"
    assert response.body =~ "Enter a long URL to have it shortened."
  end

  test "`render/2` returns the html form with the shortened URL", %{response: response} do
    assert response = %Raxx.Response{} = ShortUrl.View.render(response, "http://google.com")
    assert [{"content-type", "text/html"} | _] = response.headers

    # Form
    assert response.body =~ "Shorten URL"
    assert response.body =~ "Enter a long URL to have it shortened."

    # Shortened URL
    assert response.body =~ "Your new URL!"
    assert response.body =~ "http://localhost:8080"
  end

  test "`render_error/1` renders an error message", %{response: response} do
    assert error1 = %Raxx.Response{} = ShortUrl.View.render_error(response)
    assert [{"content-type", "text/html"} | _] = error1.headers
    assert error1.body =~ "Error: Bad Request"

    assert error2 =
             %Raxx.Response{} = ShortUrl.View.render_error(response, "Error: You messed up")

    assert [{"content-type", "text/html"} | _] = error2.headers
    assert error2.body =~ "Error: You messed up"
  end
end
