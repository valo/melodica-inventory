defmodule MelodicaInventory.TrelloCard do
  defstruct [:id, :name, :idAttachmentCover, :attachmentCover, :url, :list_id]

  def all(list_id) do
    HTTPoison.get!(cards_url(list_id), %{}, [
      params: %{
        key: Application.fetch_env!(:melodica_inventory, :api_key),
        token: Application.fetch_env!(:melodica_inventory, :token)
      }
    ])
    |> decode_response
    |> Enum.map(&(update_list_id(&1, list_id)))
    |> Enum.map(&fetch_cover/1)
  end

  defp cards_url(list_id) do
    trello_url <> "/lists/" <> list_id <> "/cards"
  end

  defp decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    Poison.decode!(body, as: [%MelodicaInventory.TrelloCard{}])
  end

  defp update_list_id(card, list_id) do
    %{card | list_id: list_id}
  end

  defp fetch_cover(%MelodicaInventory.TrelloCard{idAttachmentCover: nil}=trello_card) do
    trello_card
  end

  defp fetch_cover(%MelodicaInventory.TrelloCard{id: card_id, idAttachmentCover: attachment_id}=trello_card) do
    %{trello_card | attachmentCover: MelodicaInventory.TrelloAttachment.get(card_id, attachment_id)}
  end

  defp trello_url do
    Application.fetch_env!(:melodica_inventory, :trello_url)
  end
end
