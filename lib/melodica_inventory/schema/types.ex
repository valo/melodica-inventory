defmodule MelodicaInventory.Schema.Types do
  use Absinthe.Schema.Notation

  object :category do
    field :id, :id
    field :name, :string
    field :variations, list_of(:variation)
  end

  object :variation do
    field :id, :id
    field :name, :string
    field :items, list_of(:item)
  end

  object :item do
    field :id, :id
    field :name, :string
    field :quantity, :integer
    field :images, list_of(:string) do
      resolve &MelodicaInventory.Resolvers.Item.image_urls/3
    end
  end
end
