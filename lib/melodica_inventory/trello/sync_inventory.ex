defmodule MelodicaInventory.Trello.SyncInventory do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.Trello.Board
  alias MelodicaInventory.Trello.List
  alias MelodicaInventory.Trello.Card
  alias MelodicaInventory.Goods.Category
  alias MelodicaInventory.Goods.Variation
  alias MelodicaInventory.Goods.Item
  alias MelodicaInventory.Goods.Attachment

  require Logger

  def sync() do
    Board.all
    |> Enum.map(&find_or_create_category_from_board/1)
    |> Enum.each(&update_variations/1)
  end

  defp find_or_create_category_from_board(%Board{id: id, name: name, desc: desc}) do
    Repo.get_by(Category, uuid: id) || Repo.insert!(Category.changeset(%Category{uuid: id, name: name, desc: desc}))
  end

  defp update_variations(%Category{uuid: uuid} = category) do
    Logger.info "Updating the variations of category #{ uuid }"
    List.all(uuid)
    |> Enum.map(&find_or_create_variation_from_list(&1, category))
    |> Enum.map(&update_items/1)
  end

  defp find_or_create_variation_from_list(%List{id: id, name: name}, category) do
    Repo.get_by(Variation, uuid: id) || Repo.insert!(Variation.changeset(%Variation{uuid: id, name: name, category_id: category.id}))
  end

  defp update_items(%Variation{uuid: uuid} = variation) do
    Logger.info "Updating the items of variation #{ uuid }"
    Card.all(uuid)
    |> Enum.map(fn card ->
      item = find_or_create_item_from_card(card, variation)
      update_attachments(card, item)
    end)
  end

  defp find_or_create_item_from_card(%Card{id: id, name: name, url: url}, variation) do
    Repo.get_by(Item, uuid: id) || Repo.insert!(Item.changeset(%Item{uuid: id, name: name, variation_id: variation.id, url: url, price: 0, quantity: 0}))
  end

  defp update_attachments(%Card{idAttachmentCover: nil}, _item), do: nil
  defp update_attachments(%Card{idAttachmentCover: ""}, _item), do: nil

  defp update_attachments(%Card{idAttachmentCover: attachment_id, attachmentCover: trello_attachment}, item) do
    Repo.get_by(Attachment, uuid: attachment_id) || Repo.insert!(Attachment.changeset(%Attachment{uuid: attachment_id, item_id: item.id, url: trello_attachment.url}))
  end
end
