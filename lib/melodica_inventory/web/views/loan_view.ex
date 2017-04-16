defmodule MelodicaInventory.Web.LoanView do
  use MelodicaInventory.Web, :view

  def format_loan_date(datetime) do
    Timex.format!(datetime, "%Y-%m-%d", :strftime)
  end
end
