defmodule AmortizationScheduleCalculator do
  @moduledoc """
  A library created to calcute Amortization Schedule
  """

  @type loan_amount :: Decimal.t()
  @type annual_interest_rate :: Decimal.t()
  @type monthly_interest_rate :: Decimal.t()
  @type effective_interest_rate :: Decimal.t()
  @type term_in_months :: integer()
  @type monthly_payment :: Decimal.t()
end
