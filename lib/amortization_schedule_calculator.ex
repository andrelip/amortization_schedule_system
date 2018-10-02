defmodule AmortizationScheduleCalculator do
  @moduledoc """
  A library created to calcute Amortization Schedule
  """
  alias AmortizationScheduleCalculator.CompositeInterest
  alias AmortizationScheduleCalculator.Schedule
  alias AmortizationScheduleCalculator.ScheduleLine

  @type loan_amount :: Decimal.t()
  @type annual_interest_rate :: Decimal.t()
  @type monthly_interest_rate :: Decimal.t()
  @type effective_interest_rate :: Decimal.t()
  @type term_in_months :: integer()
  @type monthly_payment :: Decimal.t()
  @type start_date :: Date.t()

  @doc """
  Calculates the Amortization Schedule given a start monthly, total amount, interest rate and term in months.

  ## Examples

      iex> AmortizationScheduleCalculator.run(Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date, Decimal.new(100000), Decimal.new(0.06), 360) |> List.last
      %AmortizationScheduleCalculator.ScheduleLine{
             interest: Decimal.new("2.982838433595783057668961548"),
             loan_amount: Decimal.new("0"),
             month: ~D[2048-10-01],
             principal: Decimal.new("596.5676867191566115337923095"),
             total_principal_paid: Decimal.new("100000.00000000000000000000000"),
             total_interest_paid: Decimal.new("115838.1890549908620529260479"),
             total_payment: Decimal.new("599.5505251527523945914612710"),
             pay_off_achieved: true,
             monthly_extra_payment: Decimal.new("0")
           }

  """
  @spec run(start_date(), loan_amount(), annual_interest_rate(), term_in_months()) ::
          list(%ScheduleLine{})
  def run(start_date, loan_amount, annual_interest_rate, term_in_months) do
    monthly_interest_rate = Money.div!(annual_interest_rate, 12)

    monthly_payment =
      CompositeInterest.get_monthly_payment(
        loan_amount,
        monthly_interest_rate,
        term_in_months
      )

    schedule = %Schedule{
      start_date: start_date,
      term_in_months: term_in_months,
      loan_amount: loan_amount,
      monthly_payment: monthly_payment,
      monthly_interest_rate: monthly_interest_rate
    }

    Schedule.list(schedule)
  end
end
