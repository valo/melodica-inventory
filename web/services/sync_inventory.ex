defmodule MelodicaInventory.SyncInventory do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.TrelloBoard
  alias MelodicaInventory.TrelloList
  alias MelodicaInventory.TrelloCard
  alias MelodicaInventory.Category
  alias MelodicaInventory.Variation
  alias MelodicaInventory.Item
  alias MelodicaInventory.Attachment

  require Logger

  def sync() do
    TrelloBoard.all
    |> Enum.map(&find_or_create_category_from_board/1)
    |> Enum.each(&update_variations/1)
  end

  defp find_or_create_category_from_board(%TrelloBoard{id: id, name: name, desc: desc}) do
    Repo.get(Category, id) || Repo.insert!(Category.changeset(%Category{id: id, name: name, desc: desc}))
  end

  defp update_variations(%Category{id: id}) do
    Logger.info "Updating the variations of category #{ id }"
    TrelloList.all(id)
    |> Enum.map(&find_or_create_variation_from_list/1)
    |> Enum.map(&update_items/1)
  end

  defp find_or_create_variation_from_list(%TrelloList{id: id, name: name, board_id: board_id}) do
    Repo.get(Variation, id) || Repo.insert!(Variation.changeset(%Variation{id: id, name: name, category_id: board_id}))
  end

  defp update_items(%Variation{id: id}) do
    Logger.info "Updating the items of variation #{ id }"
    TrelloCard.all(id)
    |> Enum.map(&(find_or_create_item_from_card(&1) && update_attachments(&1)))
  end

  defp find_or_create_item_from_card(%TrelloCard{id: id, list_id: list_id, name: name, url: url}) do
    Repo.get(Item, id) || Repo.insert!(Item.changeset(%Item{id: id, name: name, variation_id: list_id, url: url, price: 0, quantity: 0}))
  end

  defp update_attachments(%TrelloCard{idAttachmentCover: nil}), do: nil
  defp update_attachments(%TrelloCard{idAttachmentCover: ""}), do: nil

  defp update_attachments(%TrelloCard{id: id, idAttachmentCover: attachment_id, attachmentCover: trello_attachment}) do
    Repo.get(Attachment, attachment_id) || Repo.insert!(Attachment.changeset(%Attachment{id: attachment_id, item_id: id, url: trello_attachment.url}))
  end
end
