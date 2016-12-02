defmodule MelodicaInventory.SyncInventory do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.TrelloBoard
  alias MelodicaInventory.TrelloList
  alias MelodicaInventory.TrelloCard
  alias MelodicaInventory.Category
  alias MelodicaInventory.Variation
  alias MelodicaInventory.Item

  def sync do
    TrelloBoard.all
    |> Enum.map(&find_or_create_category_from_board/1)
    |> Enum.each(&update_variations/1)
  end

  defp find_or_create_category_from_board(%TrelloBoard{id: id, name: name, desc: desc}) do
    Repo.get(Category, id) || Repo.insert!(Category.changeset(%Category{id: id, name: name, desc: desc}))
  end

  defp update_variations(%Category{id: id}) do
    TrelloList.all(id)
    |> Enum.map(&find_or_create_variation_from_list/1)
    |> Enum.map(&update_items/1)
  end

  defp find_or_create_variation_from_list(%TrelloList{id: id, name: name, board_id: board_id}) do
    Repo.get(Variation, id) || Repo.insert!(Variation.changeset(%Variation{id: id, name: name, category_id: board_id}))
  end

  defp update_items(%Variation{id: id}) do
    TrelloCard.all(id)
    |> Enum.map(&find_or_create_item_from_card/1)
  end

  defp find_or_create_item_from_card(%TrelloCard{id: id, list_id: list_id, name: name, url: url}=item) do
    Repo.get(Item, id) || Repo.insert!(Item.changeset(%Item{id: id, name: name, variation_id: list_id, url: url}))
  end
end
