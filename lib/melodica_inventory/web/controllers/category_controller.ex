defmodule MelodicaInventory.Web.CategoryController do
  @moduledoc false

  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Variation, Category, TrelloCard}

  def index(conn, _params) do
    render conn, "index.html", categories: Repo.all(Category)
  end

  def show(conn, %{"id" => category_id}) do
    category = Repo.get!(Category, category_id)
    variations =
      Variation
      |> where([v], v.category_id == ^category_id)
      |> Repo.all
      |> Repo.preload(items: [:attachments, :images])

    render conn, "show.html", variations: variations, category: category
  end

  def fetch_cards(list) do
    Task.async(fn -> TrelloCard.all(list.id) end)
  end
end
