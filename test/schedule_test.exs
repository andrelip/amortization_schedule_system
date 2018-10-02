defmodule AmortizationScheduleCalculator.ScheduleTest do
  use ExUnit.Case
  alias AmortizationScheduleCalculator.Schedule
  alias Decimal, as: D

  doctest AmortizationScheduleCalculator.Schedule

  @monthly_payment D.new("599.5505251527523945914612435")
  @monthly_interest_rate D.new("0.005")
  @start_date Timex.parse!("10/02/2018", "%m/%d/%Y", :strftime) |> Timex.to_date()
  @initial_params %Schedule{
    start_date: @start_date,
    term_in_months: 360,
    loan_amount: D.new("100000"),
    monthly_payment: @monthly_payment,
    monthly_interest_rate: @monthly_interest_rate
  }

  test "calculate schedule line" do
    schedule = Schedule.list(@initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: D.new("2.982838433595783057668961548"),
             loan_amount: D.new("0"),
             month: ~D[2048-10-01],
             principal: D.new("596.5676867191566115337923095"),
             total_principal_paid: D.new("100000.00000000000000000000000"),
             total_interest_paid: D.new("115838.1890549908620529260479"),
             total_payment: D.new("599.5505251527523945914612710"),
             pay_off_achieved: true,
             monthly_extra_payment: D.new("0")
           }
  end

  test "calculate schedule line with monthly" do
    initial_params = @initial_params |> Map.put(:monthly_extra_payment, D.new("100"))

    schedule = Schedule.list(initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: D.new("1.745044823232865517053994662"),
             loan_amount: D.new("0"),
             month: ~D[2039-10-01],
             principal: D.new("349.0089646465731034107989324"),
             total_principal_paid: D.new("99999.99999999999999999999998"),
             total_interest_paid: D.new("75937.93582281065701138462501"),
             total_payment: D.new("350.7540094698059689278529271"),
             pay_off_achieved: true,
             monthly_extra_payment: D.new("100")
           }
  end

  test "calculate schedule line with one time mortgage payment" do
    initial_params =
      @initial_params |> Map.put(:one_time_extra_payments, %{~D[2029-03-01] => 100})

    schedule = Schedule.list(initial_params)

    assert schedule |> List.last() == %AmortizationScheduleCalculator.ScheduleLine{
             interest: D.new("1.384523366159364367054500658"),
             loan_amount: D.new("0"),
             month: ~D[2048-10-01],
             principal: D.new("276.9046732318728734109001316"),
             total_principal_paid: D.new("99999.99999999999999999999999"),
             total_interest_paid: D.new("115616.9277264361418961125412"),
             total_payment: D.new("278.2891965980322377779546323"),
             pay_off_achieved: true,
             monthly_extra_payment: D.new("0")
           }
  end
end
