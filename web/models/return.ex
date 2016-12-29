defmodule MelodicaInventory.Return do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.Loan

  schema "loans" do
    belongs_to :loan, Loan
    field :quantity, :string
    field :type, :string

    timestamps()
  end

  def return_types do
    ["returned", "destroyed"]
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:loan_id, :quantity, :type])
    |> validate_required([:loan_id, :quantity, :type])
    |> validate_inclusion(:type, return_types)
  end
end
