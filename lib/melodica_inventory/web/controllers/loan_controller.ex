defmodule MelodicaInventory.Web.LoanController do
  @moduledoc false

  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Item, Loan, CreateLoan}

  def new(conn, %{"item_id" => item_id}) do
    item =
      Item
      |> Repo.get!(item_id)
      |> Repo.preload(:variation)

    changeset = Loan.changeset(%Loan{item: item, quantity: item.quantity})
    render conn, "new.html", changeset: changeset, item: item
  end

  def create(
    %Plug.Conn{assigns: %{current_user: current_user}} = conn,
    %{"item_id" => item_id, "loan" => %{"quantity" => quantity}}) do

    item =
      Item
      |> Repo.get!(item_id)
      |> Repo.preload(:variation)

    case CreateLoan.call(item, current_user, String.to_integer(quantity)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Loan created successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, loan_changeset} ->
        render(conn, "new.html", changeset: loan_changeset, item: item)
    end
  end

  def index(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _params) do
    loans =
      Loan
      |> where([l], l.user_id == ^current_user.id and not l.fulfilled)
      |> Repo.all
      |> Repo.preload(:item)
    render conn, "index.html", loans: loans
  end
end
