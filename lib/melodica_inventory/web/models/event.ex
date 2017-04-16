defmodule MelodicaInventory.Event do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.User

  schema "events" do
    belongs_to :user, User
    field :name, :string, null: false
    field :place, :string, null: false
    field :start_date, :date, null: false
    field :end_date, :date, null: false
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :name, :start_date, :end_date, :place])
    |> validate_required([:user_id, :name, :start_date, :end_date, :place])
  end
end
