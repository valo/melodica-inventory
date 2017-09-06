defmodule MelodicaInventory.Schema do
  use Absinthe.Schema
  import_types MelodicaInventory.Schema.Types

  query do
    field :categories, list_of(:category) do
      resolve &MelodicaInventory.Resolvers.Category.all/2
    end

    field :category, type: :category do
      arg :id, non_null(:id)
      resolve &MelodicaInventory.Resolvers.Category.find/2
    end

    field :item, type: :item do
      arg :id, non_null(:id)
      resolve &MelodicaInventory.Resolvers.Item.find/2
    end
  end

  mutation do
    field :like_item, :item do

    end
  end
end
