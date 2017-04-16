defmodule MelodicaInventory.Return do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Loan

  schema "returns" do
    belongs_to :loan, Loan
    field :quantity, :integer
    field :type, :string

    timestamps()
  end

  def types do
    [returned, destroyed]
  end

  def returned do
    "returned"
  end

  def destroyed do
    "destroyed"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:loan_id, :quantity, :type])
    |> validate_required([:loan_id, :quantity, :type])
    |> validate_inclusion(:type, types)
  end
end
