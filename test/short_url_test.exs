defmodule ShortUrlTest do
  use ExUnit.Case
  doctest ShortUrl

  test "greets the world" do
    assert ShortUrl.hello() == :world
  end
end
