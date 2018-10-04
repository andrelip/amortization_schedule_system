defmodule AmortizationScheduleCalculator.CompositeInterestTest do
  use ExUnit.Case
  alias AmortizationScheduleCalculator.CompositeInterest
  alias Decimal, as: D

  doctest AmortizationScheduleCalculator.CompositeInterest

  @monthly_interest_rate D.new("0.005")
  @loan_amount Money.new(:usd, "100000")

  test "calculates effective interest rate" do
    assert CompositeInterest.effective_interest_rate(360, @monthly_interest_rate) ==
             D.new("6.022575212263216184054046820")
  end

  test "calculates monthly payment" do
    assert CompositeInterest.get_monthly_payment(@loan_amount, @monthly_interest_rate, 360) ==
             Money.new(:usd, "599.5505251527523945914612435")
  end
end
