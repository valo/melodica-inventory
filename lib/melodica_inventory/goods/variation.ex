defmodule MelodicaInventory.Goods.Variation do
  @moduledoc false

  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Goods.{Category, Item}

  schema "variations" do
    belongs_to :category, Category
    has_many :items, Item, on_delete: :delete_all
    field :uuid, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :category_id, :uuid])
    |> validate_required([:name, :category_id, :uuid])
  end
end
