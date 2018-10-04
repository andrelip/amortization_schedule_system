# AmortizationScheduleCalculator

Simple library to generate an Amortization Schedule for periodic payments or installments. 
Use this table can show you how much will go toward the principal and how much will go toward the interest

[![CircleCI](https://circleci.com/gh/andrelip/amortization_schedule_system/tree/master.svg?style=svg)](https://circleci.com/gh/andrelip/amortization_schedule_system/tree/master)

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
iex> start = Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date
iex> loan = Money.new(:usd, 100000)
iex> rate = Decimal.new(0.06)
iex> term_in_months = 360
iex> %AmortizationScheduleCalculator{loan_amount: loan, annual_interest_rate: rate, start_date: start, term_in_months: 360}
|> AmortizationScheduleCalculator.run
|> List.last
%AmortizationScheduleCalculator.ScheduleLine{
        interest: Money.new(:USD, "2.982838433595783057668961548"),
        loan_amount: Money.new(:USD, "2.75E-23"),
        month: ~D[2048-10-01],
        monthly_extra_payment: Money.new(:USD, "0"),
        one_time_payments: nil,
        pay_off_achieved: false,
        principal: Money.new(:USD, "596.5676867191566115337922820"),
        total_interest_paid: Money.new(:USD, "115838.1890549908620529260479"),
        total_payment: Money.new(:USD, "599.5505251527523945914612435"),
        total_principal_paid: Money.new(:USD, "99999.99999999999999999999997")
    }
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/amortization_schedule_calculator](https://hexdocs.pm/amortization_schedule_calculator).

