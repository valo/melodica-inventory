defmodule MelodicaInventory.CreateLoan do
  alias MelodicaInventory.Loan
  alias MelodicaInventory.Item
  alias MelodicaInventory.Repo

  alias Ecto.Multi
  import Ecto.Query

  def call(item, user, quantity) do
    changeset = %Loan{item_id: item.id, user_id: user.id}
    |> Loan.changeset(%{quantity: quantity})

    changes = Ecto.Multi.new
    |> Multi.insert(:loan, changeset)
    |> Multi.update_all(:update_item, from(i in Item, where: i.id == ^item.id), inc: [quantity: -quantity])

    result = Repo.transaction(changes)

    case result do
      {:ok, %{loan: loan}} ->
        {:ok, loan}
      res ->
      {:error, res}
    end
  end
end
