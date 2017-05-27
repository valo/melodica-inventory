defmodule MelodicaInventory.CreateLoan do
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Item
  alias MelodicaInventory.Repo

  alias Ecto.Multi

  def call(item, user, quantity) do
    case Repo.transaction(build_loan(item, user, quantity)) do
      {:ok, values} ->
        {:ok, values}
      {:error, :item, _failed_value, %{loan: loan_changeset}} ->
        {:error, %{loan_changeset | action: :insert} |> Ecto.Changeset.add_error(:quantity, "Not enough items available. You can borrow at most #{item.quantity}")}
      {:error, :loan, loan_changeset, _changes_so_far} ->
        {:error, %{loan_changeset | action: :insert} |> Ecto.Changeset.add_error(:loan, "Can't create loan. Check your values")}
    end
  end

  def build_loan(item, user, quantity) do
    loan_changeset = %Loan{item_id: item.id, user_id: user.id}
    |> Loan.changeset(%{quantity: quantity})

    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity - quantity})

    Ecto.Multi.new
    |> Multi.insert(:loan, loan_changeset)
    |> Multi.update(:item, item_changeset)
  end
end
