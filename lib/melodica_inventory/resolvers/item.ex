defmodule MelodicaInventory.Resolvers.Item do
  import Ecto.Query
  alias MelodicaInventory.Repo
  alias MelodicaInventory.Goods.Item
  alias Cloudex.Url

  def image_urls(item, _args, _info) do
    {
      :ok,
      Enum.map(item.images, &image_url/1)
    }
  end

  def find(%{id: id}, _info) do
    items_with_deps
    |> Repo.get(id)
    |> case do
      nil -> {:error, "Item with id #{id} does not exist"}
      item -> {:ok, item}
    end

  end

  defp image_url(image) do
    Url.for(image.public_id, %{width: 400, height: 300, crop: "limit"})
  end

  defp items_with_deps do
    Item
    |> preload([:images, :attachments])
  end
end
