defmodule MelodicaInventory.Web.Admin.LoanReturnController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Return
  alias MelodicaInventory.ReturnLoan

  def create(conn, %{"loan_id" => loan_id, "return" => %{"quantity" => quantity, "type" => return_type}}) do
    loan = Repo.get!(Loan, loan_id)

    case ReturnLoan.call(loan, String.to_integer(quantity), return_type) do
      {:ok} ->
        put_flash(conn, :info, "Loan returned successfully")
      _ ->
        put_flash(conn, :error, "Can't return loan")
    end
    redirect conn, to: admin_loan_path(conn, :index)
  end

  def create(conn, %{"loan_id" => loan_id}) do
    loan = Repo.get!(Loan, loan_id)

    case ReturnLoan.call(loan, loan.quantity, Return.returned) do
      {:ok} ->
        put_flash(conn, :info, "Loan returned successfully")
      _ ->
        put_flash(conn, :error, "Can't return loan")
    end
    redirect conn, to: admin_loan_path(conn, :index)
  end
end
