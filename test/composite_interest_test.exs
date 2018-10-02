defmodule AmortizationScheduleCalculator.CompositeInterestTest do
  use ExUnit.Case
  alias AmortizationScheduleCalculator.CompositeInterest, as: CompositeInterest
  alias Decimal, as: D

  doctest AmortizationScheduleCalculator.CompositeInterest

  @annual_interest_rate D.new("0.06")
  @loan_amount D.new("100000")

  test "calculates effective interest rate" do
    annual_interest_rate = @annual_interest_rate
    monthly_interest_rate = D.div(annual_interest_rate, 12)

    assert CompositeInterest.effective_interest_rate(360, monthly_interest_rate) ==
             D.new("6.022575212263216184054046820")
  end

  test "calculates monthly payment" do
    assert CompositeInterest.get_monthly_payment(@loan_amount, @annual_interest_rate, 360) ==
             D.new("599.5505251527523945914612435")
  end
end
