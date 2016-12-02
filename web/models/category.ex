defmodule MelodicaInventory.Category do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Variation

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "categories" do
    has_many :variations, Variation
    field :name, :string
    field :desc, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :desc])
    |> validate_required([:name])
  end
end
