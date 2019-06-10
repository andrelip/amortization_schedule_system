defmodule AmortizationScheduleCalculator.ScheduleTest do
  use ExUnit.Case
  alias AmortizationScheduleCalculator.Schedule
  alias Decimal, as: D

  doctest AmortizationScheduleCalculator.Schedule

  @monthly_payment Money.new(:usd, "599.55")
  @monthly_interest_rate D.new("0.005")
  @start_date Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date()
  @initial_params %Schedule{
    start_date: @start_date,
    term_in_months: 360,
    loan_amount: Money.new(:usd, "100000"),
    monthly_payment: @monthly_payment,
    monthly_interest_rate: @monthly_interest_rate
  }

  test "calculate schedule line" do
    schedule = Schedule.list(@initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: Money.new(:usd, "2.99"),
             begin_balance: Money.new(:usd, "597.01"),
             end_balance: Money.new(:usd, "0.45"),
             month: ~D[2048-10-01],
             principal: Money.new(:usd, "596.56"),
             total_principal_paid: Money.new(:usd, "99999.55"),
             total_interest_paid: Money.new(:usd, "115838.45"),
             total_payment: Money.new(:usd, "599.55"),
             pay_off_achieved: false,
             monthly_extra_payment: Money.new(:usd, "0")
           }
  end

  test "calculate schedule line with monthly" do
    initial_params = @initial_params |> Map.put(:monthly_extra_payment, Money.new(:usd, "100"))

    schedule = Schedule.list(initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: Money.new(:usd, "1.75"),
             begin_balance: Money.new(:usd, "349.24"),
             end_balance: Money.new(:usd, "0"),
             month: ~D[2039-10-01],
             principal: Money.new(:usd, "349.24"),
             total_principal_paid: Money.new(:usd, "100000.00"),
             total_interest_paid: Money.new(:usd, "75938.04"),
             total_payment: Money.new(:usd, "350.99"),
             pay_off_achieved: true,
             monthly_extra_payment: Money.new(:usd, "100")
           }
  end

  test "calculate schedule line with one time mortgage payment" do
    initial_params =
      @initial_params
      |> Map.put(:one_time_extra_payments, %{~D[2029-03-01] => Money.new(:usd, 100)})

    schedule = Schedule.list(initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: Money.new(:usd, "1.39"),
             begin_balance: Money.new(:usd, "277.32"),
             end_balance: Money.new(:usd, "0"),
             month: ~D[2048-10-01],
             principal: Money.new(:usd, "277.32"),
             total_principal_paid: Money.new(:usd, "100000.00"),
             total_interest_paid: Money.new(:usd, "115617.16"),
             total_payment: Money.new(:usd, "278.71"),
             pay_off_achieved: true,
             monthly_extra_payment: Money.new(:usd, "0")
           }
  end
end
