defmodule MelodicaInventory.Item do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Variation
  alias MelodicaInventory.Attachment

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "items" do
    belongs_to :variation, Variation
    has_many :attachments, Attachment
    field :name, :string
    field :url, :string
    field :quantity, :integer
    field :price, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :variation_id, :quantity, :price])
    |> validate_required([:name, :url, :variation_id, :quantity, :price])
  end
end
