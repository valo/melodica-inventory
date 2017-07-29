defmodule MelodicaInventory.User do
  use MelodicaInventoryWeb, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :image_url, :string
    field :admin, :boolean

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :image_url])
    |> validate_required([:email, :first_name, :last_name, :image_url, :admin])
  end
end
