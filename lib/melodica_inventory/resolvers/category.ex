defmodule MelodicaInventory.Resolvers.Category do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.Goods.Category
  import Ecto.Query

  def all(_args, _info) do
    {
      :ok,
      categories_with_deps
      |> Repo.all
    }
  end

  def find(%{id: id}, _info) do
    categories_with_deps
    |> Repo.get(id)
    |> case do
      nil -> {:error, "Category with id #{id} does not exist"}
      category -> {:ok, category}
    end
  end

  defp categories_with_deps do
    Category
    |> preload(variations: [items: [:images, :attachments]])
  end
end
