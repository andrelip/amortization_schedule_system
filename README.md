# AmortizationScheduleCalculator

Simple library to generate an Amortization Schedule for periodic payments or installments. 
Using this table can can show you how much will go toward the principal and how much will go toward the interest

[![CircleCI](https://circleci.com/gh/andrelip/amortization_schedule_system/tree/master.svg?style=svg)](https://circleci.com/gh/andrelip/amortization_schedule_system/tree/master)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `amortization_schedule_calculator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:amortization_schedule_calculator, "~> 0.0.1"}
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
  interest: #Money<:USD, 2.99>,
  loan_amount: #Money<:USD, 0.45>,
  month: ~D[2048-10-01],
  monthly_extra_payment: #Money<:USD, 0>,
  one_time_payments: nil,
  pay_off_achieved: false,
  principal: #Money<:USD, 596.56>,
  total_interest_paid: #Money<:USD, 115838.45>,
  total_payment: #Money<:USD, 599.55>,
  total_principal_paid: #Money<:USD, 99999.55>
}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/amortization_schedule_calculator](https://hexdocs.pm/amortization_schedule_calculator).

