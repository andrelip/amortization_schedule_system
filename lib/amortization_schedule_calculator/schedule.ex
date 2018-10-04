defmodule AmortizationScheduleCalculator.Schedule do
  @moduledoc """
  This module has functions that populates the schedule table
  """
  defstruct([
    :start_date,
    :loan_amount,
    :monthly_payment,
    :monthly_interest_rate,
    :term_in_months,
    :monthly_extra_payment,
    :one_time_extra_payments
  ])

  alias AmortizationScheduleCalculator.ScheduleLine
  alias Decimal, as: D

  @doc """
  Populates and show the amortization schedule
  """
  def list(%__MODULE__{} = params) do
    first_month = params.start_date |> Timex.beginning_of_month()

    initial_value =
      %{
        month: first_month,
        total_interest_paid: Money.new(:usd, "0"),
        total_principal_paid: Money.new(:usd, "0")
      }
      |> Map.merge(params)
      |> Map.from_struct()

    schedule_line_params = struct(ScheduleLine, initial_value)
    term_in_months = params.term_in_months
    monthly_payment = params.monthly_payment
    ir = params.monthly_interest_rate
    one_time_extra_payments = params.one_time_extra_payments || %{}

    list =
      Enum.reduce(1..term_in_months, [schedule_line_params], fn _, acc ->
        [sl | _] = acc

        [ScheduleLine.calculate_line(sl, monthly_payment, ir, one_time_extra_payments) | acc]
      end)

    list |> clean_months_after_payoff |> Enum.reverse()
  end

  defp clean_months_after_payoff(list) do
    Enum.filter(list, fn item -> item != nil end)
  end
end
