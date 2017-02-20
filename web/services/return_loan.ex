defmodule MelodicaInventory.ReturnLoan do
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Item
  alias MelodicaInventory.Return
  alias MelodicaInventory.Repo

  alias Ecto.Multi

  def call(loan, quantity, return_type) do
    changes = Ecto.Multi.new
    |> loan_update(loan, quantity)
    |> create_return(loan, quantity, return_type)
    |> update_item(loan, quantity, return_type)

    case Repo.transaction(changes) do
      {:ok, values} ->
        {:ok, values}
      {:error, _failed_key, _failed_operation, _changes_so_far} ->
        {:error}
    end
  end

  defp loan_update(multi, loan, quantity) do
    loan_changeset = loan
    |> Loan.changeset(%{fulfilled: quantity == loan.quantity, quantity: loan.quantity - quantity})

    Multi.update(multi, :loan, loan_changeset)
  end

  defp create_return(multi, loan, quantity, return_type) do
    return_changeset = %Return{loan_id: loan.id, quantity: quantity, type: return_type}
    |> Return.changeset

    Multi.insert(multi, :return, return_changeset)
  end

  defp update_item(multi, loan, quantity, "returned") do
    item = Repo.get!(Item, loan.item_id)
    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity + quantity})

    Multi.update(multi, :item, item_changeset)
  end

  defp update_item(multi, loan, quantity, "destroyed") do
    item = Repo.get!(Item, loan.item_id)
    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity})

    Multi.update(multi, :item, item_changeset)
  end
end
