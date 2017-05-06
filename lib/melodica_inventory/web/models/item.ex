defmodule MelodicaInventory.Item do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.{Variation, Attachment, Image}

  schema "items" do
    belongs_to :variation, Variation
    has_many :attachments, Attachment, on_delete: :delete_all
    has_many :images, Image, on_delete: :delete_all
    field :uuid, :string
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
    |> cast(params, [:name, :url, :variation_id, :quantity, :price, :uuid])
    |> validate_required([:name, :variation_id, :quantity, :price])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
