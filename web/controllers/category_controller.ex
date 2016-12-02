defmodule MelodicaInventory.CategoryController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.TrelloList
  alias MelodicaInventory.TrelloCard

  def show(conn, %{"category_id" => category_id}) do
    lists = TrelloList.all(category_id)
    cards =
      lists
      |> Enum.map(&fetch_cards/1)
      |> Enum.map(&Task.await/1)

    render conn, "show.html", lists: lists, cards: cards
  end

  def fetch_cards(list) do
    Task.async(fn -> TrelloCard.all(list.id) end)
  end
end
