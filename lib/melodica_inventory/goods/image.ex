defmodule MelodicaInventory.Goods.Image do
  @moduledoc false

  use MelodicaInventoryWeb, :model

  alias MelodicaInventory.Goods.Item

  schema "images" do
    belongs_to :item, Item
    field :public_id, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:item_id, :public_id])
    |> validate_required([:item_id, :public_id])
  end
end
