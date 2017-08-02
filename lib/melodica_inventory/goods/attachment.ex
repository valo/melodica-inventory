defmodule MelodicaInventory.Goods.Attachment do
  @moduledoc false

  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Goods.Item

  schema "attachments" do
    belongs_to :item, Item
    field :uuid, :string
    field :url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :item_id, :uuid])
    |> validate_required([:url, :item_id, :uuid])
  end
end
