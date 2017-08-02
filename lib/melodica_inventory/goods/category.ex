defmodule MelodicaInventory.Goods.Category do
  @moduledoc false

  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Goods.Variation

  schema "categories" do
    has_many :variations, Variation, on_delete: :delete_all
    field :uuid, :string
    field :name, :string
    field :desc, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :desc, :uuid])
    |> validate_required([:name, :uuid])
  end
end
