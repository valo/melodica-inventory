defmodule MelodicaInventory.Admin.LoanController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Loan

  def index(conn, _params) do
    loans = (from l in Loan, where: not l.fulfilled)
    |> Repo.all
    |> Repo.preload([:item, :user])
    render conn, "index.html", loans: loans
  end
end
