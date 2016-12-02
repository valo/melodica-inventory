defmodule MelodicaInventory.Variation do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Category
  alias MelodicaInventory.Item

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "variations" do
    belongs_to :category, Category
    has_many :items, Item
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :category_id])
    |> validate_required([:name, :category_id])
  end
end
