defmodule MelodicaInventory.Admin.CategoryController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Category

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Category, id)
    |> Category.changeset

    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    changeset = Repo.get!(Category, id)
    |> Category.changeset(category_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.delete!(Category, id)

    redirect(conn, to: page_path(conn, :index))
  end
end
