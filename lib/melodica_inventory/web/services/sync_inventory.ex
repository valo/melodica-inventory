defmodule MelodicaInventory.SyncInventory do
  @moduledoc false

  alias MelodicaInventory.{Repo, TrelloCard, TrelloList, TrelloBoard, Category, Variation, Item, Attachment}

  require Logger

  def sync do
    TrelloBoard.all
    |> Enum.map(&find_or_create_category_from_board/1)
    |> Enum.each(&update_variations/1)
  end

  defp find_or_create_category_from_board(%TrelloBoard{id: id, name: name, desc: desc}) do
    Repo.get_by(Category, uuid: id) || Repo.insert!(Category.changeset(%Category{uuid: id, name: name, desc: desc}))
  end

  defp update_variations(%Category{uuid: uuid} = category) do
    Logger.info "Updating the variations of category #{ uuid }"
    uuid
    |> TrelloList.all()
    |> Enum.map(&find_or_create_variation_from_list(&1, category))
    |> Enum.map(&update_items/1)
  end

  defp find_or_create_variation_from_list(%TrelloList{id: id, name: name}, category) do
    Repo.get_by(Variation, uuid: id)
      || Repo.insert!(Variation.changeset(%Variation{uuid: id, name: name, category_id: category.id}))
  end

  defp update_items(%Variation{uuid: uuid} = variation) do
    Logger.info "Updating the items of variation #{ uuid }"
    uuid
    |> TrelloCard.all()
    |> Enum.map(fn card ->
      item = find_or_create_item_from_card(card, variation)
      update_attachments(card, item)
    end)
  end

  defp find_or_create_item_from_card(%TrelloCard{id: id, name: name, url: url}, variation) do
    Repo.get_by(Item, uuid: id)
      || Repo.insert!(Item.changeset(
          %Item{uuid: id, name: name, variation_id: variation.id, url: url, price: 0, quantity: 0}
         ))
  end

  defp update_attachments(%TrelloCard{idAttachmentCover: nil}, _item), do: nil
  defp update_attachments(%TrelloCard{idAttachmentCover: ""}, _item), do: nil

  defp update_attachments(%TrelloCard{idAttachmentCover: attachment_id, attachmentCover: trello_attachment}, item) do
    Repo.get_by(Attachment, uuid: attachment_id) ||
      Repo.insert!(Attachment.changeset(%Attachment{uuid: attachment_id, item_id: item.id, url: trello_attachment.url}))
  end
end
