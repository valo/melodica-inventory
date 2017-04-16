defmodule MelodicaInventory.CreateLoan do
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Item
  alias MelodicaInventory.Repo

  alias Ecto.Multi

  def call(item, user, quantity) do
    loan_changeset = %Loan{item_id: item.id, user_id: user.id}
    |> Loan.changeset(%{quantity: quantity})

    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity - quantity})

    changes = Ecto.Multi.new
    |> Multi.insert(:loan, loan_changeset)
    |> Multi.update(:item, item_changeset)

    case Repo.transaction(changes) do
      {:ok, values} ->
        {:ok, values}
      {:error, failed_key, failed_value, changes_so_far} ->
        {:error, %{loan_changeset | action: :insert} |> Ecto.Changeset.add_error(:loan, "Can't create loan. Check your values")}
    end
  end
end
