defmodule MelodicaInventory.Loans.Loan do
  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Accounts.User
  alias MelodicaInventory.Goods.Item
  alias MelodicaInventory.Loans.Return

  schema "loans" do
    belongs_to :user, User
    belongs_to :item, Item
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
