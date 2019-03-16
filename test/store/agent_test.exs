defmodule ShortUrl.Store.AgentTest do
  use ExUnit.Case, async: true

  alias ShortUrl.Store.Agent, as: Store

  test "`commit/1` stores a URI with a generated key" do
    assert {:ok, key} = Store.commit("http://google.com")
    assert String.length(key) == 8
  end

  test "`commit/1` does not change the key if URI exists" do
    assert {:ok, key1} = Store.commit("http://google.com")
    assert {:ok, key2} = Store.commit("http://google.com")

    assert key1 == key2
  end

  test "`lookup/`1 retrieves a URI using a key" do
    assert {:ok, key} = Store.commit("http://facebook.com")
    assert {:ok, "http://facebook.com"} = Store.lookup(key)
    assert {:error, :not_found} = Store.lookup("no-key")
  end
end
