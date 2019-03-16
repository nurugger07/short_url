defmodule ShortUrl.RouteHelperTest do
  use ExUnit.Case, async: true

  alias ShortUrl.RouteHelper

  @store Application.get_env(:short_url, :store, ShortUrl.Store.Agent)
  @uri "http://google.com"

  setup do
    {:ok, key} = @store.commit(@uri)
    {:ok, %{key: key}}
  end

  test "`validate_uri/1` returns an error with the URI is not valid" do
    assert {:error, :invalid_uri} = RouteHelper.validate_uri("bad-url")
    assert {:error, :invalid_uri} = RouteHelper.validate_uri("google.com")
  end

  test "`validate_uri/1` returns `{:ok, uri}` if valid" do
    assert {:ok, "http://google.com"} = RouteHelper.validate_uri("http://google.com")
    assert {:ok, "https://google.com"} = RouteHelper.validate_uri("https://google.com")
  end

  test "`redirect_to_path/1` redirects to a URI", %{key: key} do
    assert %Raxx.Response{} = response = RouteHelper.redirect_to_path(key)
    assert %{body: false, headers: [{"location", @uri}], status: 303} = response
  end

  test "`redirect_to_path/1` returns an error if the URI isn't found" do
    assert %Raxx.Response{} = response = RouteHelper.redirect_to_path("bad-key")
    assert %{body: "Error: No matching URI", status: 404} = response
  end

  test "`commit_uri/1` writes the uri to the data store and returns short uri" do
    assert {:ok, <<"http://localhost:8080/", key::binary-size(8)>>} = RouteHelper.commit_uri(@uri)
  end
end
