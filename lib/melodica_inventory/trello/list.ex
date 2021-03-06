defmodule MelodicaInventory.Trello.List do
  @moduledoc false

  alias MelodicaInventory.Trello.List

  defstruct [:id, :name, :board_id]

  def all(board_id) do
    HTTPoison.get!(lists_url(board_id), %{}, [
      params: %{
        key: Application.fetch_env!(:melodica_inventory, :api_key),
        token: Application.fetch_env!(:melodica_inventory, :token)
      }
    ])
    |> decode_response
    |> Enum.map(&(set_board_id(&1, board_id)))
  end

  defp lists_url(board_id) do
    trello_url <> "/boards/" <> board_id <> "/lists"
  end

  defp decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    Poison.decode!(body, as: [%List{}])
  end

  defp set_board_id(trello_list, board_id) do
    %{trello_list | board_id: board_id}
  end

  defp trello_url do
    Application.fetch_env!(:melodica_inventory, :trello_url)
  end
end
