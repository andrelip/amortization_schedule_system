defmodule AmortizationScheduleCalculator.Cldr do
  @moduledoc """
  Cldr backend
  """
  use Cldr,
    otp_app: :amortization_schedule_calculator,
    providers: [Cldr.Number]
end
