defmodule MelodicaInventoryWeb.CategoryController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Variation
  alias MelodicaInventory.Category
  alias MelodicaInventory.Trello.Card

  def index(conn, _params) do
    render conn, "index.html", categories: Repo.all(Category)
  end

  def show(conn, %{"id" => category_id}) do
    category = Repo.get!(Category, category_id)
    variations =
      from(v in Variation, where: v.category_id == ^category_id, preload: [items: [:attachments, :images]])
      |> Repo.all

    render conn, "show.html", variations: variations, category: category
  end

  def fetch_cards(list) do
    Task.async(fn -> Card.all(list.id) end)
  end
end
