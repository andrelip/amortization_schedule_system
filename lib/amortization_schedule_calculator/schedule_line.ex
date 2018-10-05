defmodule AmortizationScheduleCalculator.ScheduleLine do
  @moduledoc """
  Functions that populate the schedule table line
  """
  defstruct([
    :month,
    :loan_amount,
    :interest,
    :principal,
    :total_interest_paid,
    :total_payment,
    :total_principal_paid,
    :monthly_extra_payment,
    :one_time_payments,
    :pay_off_achieved
  ])

  def calculate_line(nil, _, _, _) do
    nil
  end

  def calculate_line(%__MODULE__{pay_off_achieved: true} = _, _, _, _) do
    nil
  end

  def calculate_line(
        %__MODULE__{} = sl,
        monthly_payment,
        monthly_interest_rate,
        one_time_payments
      ) do
    pay_off_achieved = false
    monthly_extra_payment = sl.monthly_extra_payment || Money.new(:usd, "0")
    one_time_payment = one_time_payments[sl.month] || Money.new(:usd, "0")

    total_payment =
      calculate_total_payment(monthly_payment, monthly_extra_payment, one_time_payment)

    interest = sl.loan_amount |> Money.mult!(monthly_interest_rate) |> Money.round()
    principal = total_payment |> Money.sub!(interest) |> Money.round()
    total_interest_paid = Money.add!(sl.total_interest_paid, interest)
    total_principal_paid = Money.add!(sl.total_principal_paid, principal)
    loan_amount = Money.sub!(sl.loan_amount, principal)

    minimum_chargeable = loan_amount |> Money.mult!(100) |> Money.div!(100)

    # IO.inspect(
    #   {minimum_chargeable, Money.cmp!(minimum_chargeable, Money.new(:usd, 0)) == :lt,
    #    Money.equal?(minimum_chargeable, 0)}
    # )

    {final_total_payment, final_principal, final_total_principal_paid, final_pay_off_achieved,
     final_loan_amount} =
      if Money.cmp!(minimum_chargeable, Money.new(:usd, 0)) == :lt ||
           Money.equal?(minimum_chargeable, Money.new(:usd, 0)) do
        # reduces total_payment
        new_total_payment = total_payment = total_payment |> Money.add!(loan_amount)
        new_principal = total_payment |> Money.sub!(interest) |> Money.round()
        new_total_principal_paid = Money.add!(total_principal_paid, loan_amount)
        new_pay_off_achieved = true
        new_loan_amount = Money.new(:usd, "0")

        {new_total_payment, new_principal, new_total_principal_paid, new_pay_off_achieved,
         new_loan_amount}
      else
        {total_payment, principal, total_principal_paid, pay_off_achieved, loan_amount}
      end

    %__MODULE__{
      month: sl.month |> Timex.shift(months: 1),
      total_payment: final_total_payment,
      interest: interest,
      principal: final_principal,
      total_interest_paid: total_interest_paid,
      total_principal_paid: final_total_principal_paid,
      loan_amount: final_loan_amount,
      pay_off_achieved: final_pay_off_achieved,
      monthly_extra_payment: monthly_extra_payment
    }
  end

  def calculate_total_payment(monthly_payment, monthly_extra_payment, one_time_payment) do
    monthly_payment
    |> Money.add!(monthly_extra_payment)
    |> Money.add!(one_time_payment)
  end
end
