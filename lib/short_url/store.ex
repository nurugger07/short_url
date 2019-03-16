defmodule ShortUrl.Store do
  @moduledoc """

  """

  @callback commit(String.t) :: {:ok, String.t} | {:error, String.t}
  @callback lookup(String.t) :: {:ok, String.t} | {:error, Atom.t}

end
