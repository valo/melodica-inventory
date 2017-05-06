defmodule MelodicaInventory.Web.CategoryController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Variation
  alias MelodicaInventory.Category
  alias MelodicaInventory.TrelloCard

  def index(conn, _params) do
    render conn, "index.html", categories: Repo.all(Category)
  end

  def show(conn, %{"id" => category_id}) do
    category = Repo.get!(Category, category_id)
    variations =
      from(v in Variation, where: v.category_id == ^category_id, preload: [items: :attachments])
      |> Repo.all

    render conn, "show.html", variations: variations, category: category
  end

  def fetch_cards(list) do
    Task.async(fn -> TrelloCard.all(list.id) end)
  end
end
