# AmortizationScheduleCalculator

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `amortization_schedule_calculator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:amortization_schedule_calculator, "~> 0.1.0"}
  ]
end
```

## How to Use

```elixir
start_date = Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date()
loan_amount = Decimal.new(100000)
monthly_interest_rate = Decimal.new(0.005)
term_in_months = 360
AmortizationScheduleCalculator.run(start_date, loan_amount, monthly_interest_rate, term_in_months)
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/amortization_schedule_calculator](https://hexdocs.pm/amortization_schedule_calculator).

