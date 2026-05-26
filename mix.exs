# ABOUTME: Minimal Mix project for chug-testing, used to test the mix chug.new task.
# ABOUTME: Pulls chug directly from the crayment/chug GitHub repo for pre-release testing.

defmodule ChugTesting.MixProject do
  use Mix.Project

  def project do
    [
      app: :chug_testing,
      version: "0.1.0",
      elixir: "~> 1.19",
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:chug, github: "crayment/chug", sparse: "elixir", branch: "main", only: :dev, runtime: false}
    ]
  end
end
