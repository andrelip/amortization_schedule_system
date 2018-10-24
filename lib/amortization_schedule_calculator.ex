defmodule AmortizationScheduleCalculator do
  @moduledoc """
  A library created to calculate a loan amortization schedule.
  """
  alias AmortizationScheduleCalculator.CompositeInterest
  alias AmortizationScheduleCalculator.Schedule
  alias AmortizationScheduleCalculator.ScheduleLine

  defstruct([
    :start_date,
    :loan_amount,
    :annual_interest_rate,
    :term_in_months,
    :monthly_extra_payment,
    :one_time_extra_payments
  ])

  @type loan_amount :: Decimal.t()
  @type annual_interest_rate :: Decimal.t()
  @type monthly_interest_rate :: Decimal.t()
  @type effective_interest_rate :: Decimal.t()
  @type monthly_extra_payment :: Decimal.t()
  @type one_time_extra_payments :: list(Decimal.t())
  @type term_in_months :: integer()
  @type monthly_payment :: Decimal.t()
  @type start_date :: Date.t()
  @type t :: %__MODULE__{
          start_date: start_date(),
          loan_amount: Decimal.t(),
          annual_interest_rate: annual_interest_rate(),
          term_in_months: term_in_months(),
          monthly_extra_payment: monthly_payment(),
          one_time_extra_payments: one_time_extra_payments()
        }

  @doc """
  Calculates the Amortization Schedule given a start monthly, total amount, interest rate and term in months.

  ## Examples

      iex> start = Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date
      iex> loan = Money.new(:usd, 100000)
      iex> rate = Decimal.new(0.06)
      iex> term_in_months = 360
      iex> %AmortizationScheduleCalculator{loan_amount: loan, annual_interest_rate: rate, start_date: start, term_in_months: term_in_months} |> AmortizationScheduleCalculator.run |> List.last
      %AmortizationScheduleCalculator.ScheduleLine{
             interest: Money.new(:USD, "2.99"),
             loan_amount: Money.new(:USD, "0.45"),
             month: ~D[2048-10-01],
             monthly_extra_payment: Money.new(:USD, "0"),
             one_time_payments: nil,
             pay_off_achieved: false,
             principal: Money.new(:USD, "596.56"),
             total_interest_paid: Money.new(:USD, "115838.45"),
             total_payment: Money.new(:USD, "599.55"),
             total_principal_paid: Money.new(:USD, "99999.55")
           }

  """
  @spec run(t()) :: list(%ScheduleLine{})
  def run(%__MODULE__{} = params) do
    monthly_interest_rate = Decimal.div(params.annual_interest_rate, 12)

    monthly_payment =
      CompositeInterest.get_monthly_payment(
        params.loan_amount,
        monthly_interest_rate,
        params.term_in_months
      )

    monthly_extra_payment = params.monthly_extra_payment || Money.new(:usd, 0)
    one_time_extra_payments = params.one_time_extra_payments || %{}

    schedule = %Schedule{
      start_date: params.start_date,
      term_in_months: params.term_in_months,
      loan_amount: params.loan_amount,
      monthly_payment: monthly_payment,
      monthly_interest_rate: monthly_interest_rate,
      monthly_extra_payment: monthly_extra_payment,
      one_time_extra_payments: one_time_extra_payments
    }

    Schedule.list(schedule)
  end
end
