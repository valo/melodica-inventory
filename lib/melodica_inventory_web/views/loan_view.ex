defmodule MelodicaInventoryWeb.LoanView do
  use MelodicaInventoryWeb, :view

  def format_loan_date(datetime) do
    Timex.format!(datetime, "%Y-%m-%d", :strftime)
  end
end
