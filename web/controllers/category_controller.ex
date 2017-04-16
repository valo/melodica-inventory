defmodule MelodicaInventory.Web.CategoryController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Variation
  alias MelodicaInventory.TrelloCard

  def show(conn, %{"id" => category_id}) do
    variations =
      from(v in Variation, where: v.category_id == ^category_id, preload: [items: :attachments])
      |> Repo.all

    render conn, "show.html", variations: variations
  end

  def fetch_cards(list) do
    Task.async(fn -> TrelloCard.all(list.id) end)
  end
end
