defmodule MelodicaInventory.Accounts.Customer do
  @moduledoc false

  use MelodicaInventoryWeb, :model

  schema "customers" do
    field :email, :string
    field :name, :string
    field :image_url, :string
    field :approved, :boolean

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :image_url])
    |> validate_required([:email, :name, :image_url])
  end
end
