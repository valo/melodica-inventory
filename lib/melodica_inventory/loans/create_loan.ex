defmodule MelodicaInventory.Loans.CreateLoan do
  alias MelodicaInventory.Loans.Loan
  alias MelodicaInventory.Goods.Item
  alias MelodicaInventory.Repo

  alias Ecto.Multi

  def call(item, user, quantity) do
    case Repo.transaction(build_loan(item, user, quantity)) do
      {:ok, values} ->
        {:ok, values}
      {:error, :item, _, _} ->
        {:error, %{loan_changeset(item, user, quantity) | action: :insert} |> Ecto.Changeset.add_error(:quantity, "Not enough items available. You can borrow at most #{item.quantity}")}
      {:error, :loan, _, _} ->
        {:error, %{loan_changeset(item, user, quantity) | action: :insert} |> Ecto.Changeset.add_error(:loan, "Can't create loan. Check your values")}
    end
  end

  def build_loan(item, user, quantity) do
    item_changeset = item
    |> Item.changeset(%{quantity: item.quantity - quantity})

    Ecto.Multi.new
    |> Multi.insert(:loan, loan_changeset(item, user, quantity))
    |> Multi.update(:item, item_changeset)
  end

  def build_from_reservation(reservation, user) do
    Ecto.Multi.new()
    |> Ecto.Multi.append(build_loan(reservation.item, user, reservation.quantity))
    |> Ecto.Multi.delete(:delete_reservation, reservation)
  end

  defp loan_changeset(item, user, quantity) do
    %Loan{item_id: item.id, user_id: user.id}
    |> Loan.changeset(%{quantity: quantity})
  end
end
