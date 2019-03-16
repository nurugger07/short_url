defmodule ShortUrl.Store.HelperTest do
  use ExUnit.Case, async: true

  doctest ShortUrl.Store.Helper

  alias ShortUrl.Store.Helper

  test "`generate_key/0` should generate a random and unique 8 character binary" do
    key1 = Helper.generate_key
    key2 = Helper.generate_key

    assert String.length(key1) == 8
    assert String.length(key2) == 8
    assert key1 != key2
  end
end
