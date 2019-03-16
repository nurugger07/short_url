defmodule ShortUrl.Store.GenServerTest do
  use ExUnit.Case, async: true

  alias ShortUrl.Store.GenServer, as: Store

  test "`commit/1` stores a URI with a generated key" do
    assert {:ok, key} = Store.commit("http://google.com")
    assert String.length(key) == 8
  end

  test "`lookup/`1 retrieves a URI using a key" do
    assert {:ok, key} = Store.commit("http://facebook.com")
    assert {:ok, "http://facebook.com"} = Store.lookup(key)
    assert {:error, :not_found} = Store.lookup("no-key")
  end
end
