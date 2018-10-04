defmodule AmortizationScheduleCalculator.ScheduleLineTest do
  use ExUnit.Case
  alias AmortizationScheduleCalculator.ScheduleLine
  alias Decimal, as: D

  doctest AmortizationScheduleCalculator.ScheduleLine

  @monthly_payment Money.new(:usd, "599.5505251527523945914612435")
  @monthly_interest_rate D.new("0.005")

  test "calculate schedule line" do
    start_date = Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date()

    initial_params = %ScheduleLine{
      month: start_date,
      loan_amount: Money.new(:usd, "100000"),
      total_interest_paid: Money.new(:usd, "0"),
      total_principal_paid: Money.new(:usd, "0")
    }

    month1 =
      ScheduleLine.calculate_line(initial_params, @monthly_payment, @monthly_interest_rate, %{})

    month2 = ScheduleLine.calculate_line(month1, @monthly_payment, @monthly_interest_rate, %{})

    assert month1 == %ScheduleLine{
             month: ~D[2018-11-02],
             interest: Money.new(:usd, "500.000"),
             loan_amount: Money.new(:usd, "99900.44947484724760540853876"),
             principal: Money.new(:usd, "99.5505251527523945914612435"),
             total_interest_paid: Money.new(:usd, "500.000"),
             total_payment: Money.new(:usd, "599.5505251527523945914612435"),
             total_principal_paid: Money.new(:usd, "99.5505251527523945914612435"),
             pay_off_achieved: false,
             monthly_extra_payment: Money.new(:usd, "0")
           }

    assert month2 == %AmortizationScheduleCalculator.ScheduleLine{
             month: ~D[2018-12-02],
             interest: Money.new(:usd, "499.5022473742362380270426938"),
             loan_amount: Money.new(:usd, "99800.40119706873144884412021"),
             principal: Money.new(:usd, "100.0482777785161565644185497"),
             total_interest_paid: Money.new(:usd, "999.5022473742362380270426938"),
             total_payment: Money.new(:usd, "599.5505251527523945914612435"),
             total_principal_paid: Money.new(:usd, "199.5988029312685511558797932"),
             pay_off_achieved: false,
             monthly_extra_payment: Money.new(:usd, "0")
           }
  end
end
