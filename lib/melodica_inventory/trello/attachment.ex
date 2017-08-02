defmodule MelodicaInventory.Trello.Attachment do
  @moduledoc false

  @fields [:id, :url, :previews]
  defstruct @fields

  defmodule Preview do
    @moduledoc false
    @fields [:url, :width, :height]
    defstruct @fields
  end

  def get(card_id, attachment_id) do
    HTTPoison.get!(get_attachment_url(card_id, attachment_id), %{}, [
      params: %{
        key: Application.fetch_env!(:melodica_inventory, :api_key),
        token: Application.fetch_env!(:melodica_inventory, :token)
      }
    ])
    |> decode_response
  end

  defp get_attachment_url(card_id, attachment_id) do
    trello_url() <> "/cards/" <> card_id <> "/attachments/" <> attachment_id
  end

  defp decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    Poison.decode!(body, as: %MelodicaInventory.Trello.Attachment{previews: [%Preview{}]})
  end

  defp trello_url do
    Application.fetch_env!(:melodica_inventory, :trello_url)
  end
end
