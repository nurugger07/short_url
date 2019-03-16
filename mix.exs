defmodule ShortUrl.MixProject do
  use Mix.Project

  def project do
    [
      app: :short_url,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ShortUrl.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:ace, "~> 0.18.4"},
      {:raxx, "~> 0.18.1"}
    ]
  end
end
