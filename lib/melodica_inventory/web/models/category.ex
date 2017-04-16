defmodule MelodicaInventory.Category do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Variation

  schema "categories" do
    has_many :variations, Variation
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
