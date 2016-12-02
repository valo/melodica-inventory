defmodule MelodicaInventory.Attachment do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Item

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "attachments" do
    belongs_to :item, Item
    field :url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_required([:url])
  end
end
