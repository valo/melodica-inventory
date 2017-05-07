defmodule MelodicaInventory.Web.Admin.VariationController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Variation, Item}

  def edit(conn, %{"id" => id}) do
    variation = Repo.get!(Variation, id)
    changeset = Variation.changeset(variation)

    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"id" => id, "variation" => variation_params}) do
    variation = Repo.get!(Variation, id)

    changeset = Variation.changeset(variation, variation_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Variation updated successfully")
        |> redirect(to: category_path(conn, :show, variation.category_id))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def new(conn, %{"category_id" => category_id}) do
    changeset = Variation.changeset(%Variation{category_id: category_id})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"variation" => variation_params}) do
    changeset = Variation.changeset(%Variation{uuid: Ecto.UUID.generate()}, variation_params)

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
    |> Repo.preload(items: [:loans])

    Ecto.Multi.new
    |> delete_items(variation.items)
    |> Ecto.Multi.delete(:delete_variation, variation)
    |> Repo.transaction
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "#{variation.name} delete successfully!")
        |> redirect(to: category_path(conn, :show, variation.category_id))
      {:error, error} ->
        conn
        |> put_flash(:danger, "Can't delete variation! Error: #{ error }")
        |> redirect(to: category_path(conn, :show, variation.category_id))
    end
  end

  defp delete_items(multi, items) do
    items
    |> Enum.reduce(multi, fn item, m ->
      Ecto.Multi.delete(m, :delete_item, item)
    end)
  end
end
