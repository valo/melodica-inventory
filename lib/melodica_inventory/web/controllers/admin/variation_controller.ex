defmodule MelodicaInventory.Web.Admin.VariationController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Variation

  def edit(conn, %{"id" => id}) do
    variation = Repo.get!(Variation, id)
    changeset = Variation.changeset(variation)

    render conn, "edit.html", changeset: changeset
  end

  def new(conn, %{"category_id" => category_id}) do
    changeset = Variation.changeset(%Variation{category_id: category_id})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"variation" => variation_params}) do
    changeset = Variation.changeset(%Variation{uuid: Ecto.UUID.generate()}, variation_params)

    IO.inspect changeset
    case Repo.insert(changeset) do
      {:ok, variation} ->
        conn
        |> put_flash(:info, "Variation created successfully.")
        |> redirect(to: category_path(conn, :show, variation.category_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    variation = Repo.get!(Variation, id)

    Repo.delete!(variation)

    conn
    |> put_flash(:info, "#{variation.name} delete successfully!")
    |> redirect(to: category_path(conn, :show, variation.category_id))
  end
end
