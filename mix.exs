defmodule AmortizationScheduleCalculator.MixProject do
  use Mix.Project

  def project do
    [
      app: :amortization_schedule_calculator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.MD", "LICENSE*"],
      maintainers: ["André Stephano"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/andrelip/amortization_schedule_system"}
    ]
  end

  defp description do
    """
    Amortization Schedule generator for periodic payments or installments.
    Using this table can show you how much will go toward the principal and how much will go toward the interest for each month.
    """
  end

  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:decimal, "~> 1.6"},
      {:timex, "~> 3.6"},
      {:ex_doc, "~> 0.20.0", only: :dev},
      {:ex_money, "~> 4.0"}
    ]
  end
end
