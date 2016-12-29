defmodule MelodicaInventory.LoanController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Item
  alias MelodicaInventory.Loan

  def new(conn, %{"item_id" => item_id}) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:variation)

    changeset = Loan.changeset(%Loan{item: item})
    render conn, "new.html", changeset: changeset, item: item
  end

  def create(conn, %{"item_id" => item_id, "loan" => %{"quantity" => quantity}}) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:variation)

    changeset = %Loan{item_id: item_id, user_id: conn.assigns[:current_user].id}
    |> Loan.changeset(%{quantity: quantity})

    case Repo.insert(changeset) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan created successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, changeset} ->
        IO.puts(inspect(changeset))
        render(conn, "new.html", changeset: changeset, item: item)
    end
  end
end
