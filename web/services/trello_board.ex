defmodule MelodicaInventory.TrelloBoard do
  defstruct [:id, :name, :desc]

  def all do
    HTTPoison.get!(get_boards_url, %{}, [
      params: %{
        key: Application.fetch_env!(:melodica_inventory, :api_key),
        token: Application.fetch_env!(:melodica_inventory, :token)
      }
    ]) |> decode_response
  end

  defp get_boards_url do
    trello_url <> "/organizations/" <> inventory_org_id <> "/boards"
  end

  defp inventory_org_id do
    Application.fetch_env!(:melodica_inventory, :inventory_org_id)
  end

  defp decode_response(%HTTPoison.Response{body: body}) do
    Poison.decode!(body, as: [%MelodicaInventory.TrelloBoard{}])
  end

  defp trello_url do
    Application.fetch_env!(:melodica_inventory, :trello_url)
  end
end
