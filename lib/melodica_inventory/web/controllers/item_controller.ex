defmodule MelodicaInventory.Web.ItemController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Item
  alias MelodicaInventory.Loan

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload(:attachments)

    loans = (from l in Loan, where: l.item_id == ^id and not l.fulfilled)
    |> Repo.all
    |> Repo.preload([:item, :user])

    render conn, "show.html", item: item, loans: loans
  end
end
