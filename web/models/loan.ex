defmodule MelodicaInventory.Loan do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.User
  alias MelodicaInventory.Item
  alias MelodicaInventory.Return

  schema "loans" do
    belongs_to :user, User
    belongs_to :item, Item, type: :string
    has_many :returns, Return
    field :quantity, :integer
    field :fulfilled, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :item_id, :quantity, :fulfilled])
    |> validate_required([:user_id, :item_id, :quantity, :fulfilled])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
