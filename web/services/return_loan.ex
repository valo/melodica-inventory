defmodule MelodicaInventory.ReturnLoan do
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Item
  alias MelodicaInventory.Return
  alias MelodicaInventory.Repo

  alias Ecto.Multi

  def call(loan, quantity, return_type) do
    loan_changeset = loan
    |> Loan.changeset(%{fulfilled: quantity == loan.quantity, quantity: loan.quantity - quantity})

    item = Repo.get!(Item, loan.item_id)
    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity + quantity})

    return_changeset = %Return{loan_id: loan.id, quantity: quantity, type: return_type}
    |> Return.changeset

    changes = Ecto.Multi.new
    |> Multi.update(:loan, loan_changeset)
    |> Multi.update(:item, item_changeset)
    |> Multi.insert(:return, return_changeset)

    case Repo.transaction(changes) do
      {:ok, values} ->
        {:ok, values}
      {:error, _failed_key, _failed_value, _changes_so_far} ->
        IO.inspect(_failed_value)
        {:error, %{loan_changeset | action: :update} |> Ecto.Changeset.add_error(:loan, "Can't return loan")}
    end
  end
end
