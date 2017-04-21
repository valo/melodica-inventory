defmodule MelodicaInventory.Event do
  use MelodicaInventory.Web, :model
  alias MelodicaInventory.User
  alias MelodicaInventory.ItemReservation

  schema "events" do
    belongs_to :user, User
    has_many :item_reservations, ItemReservation, on_delete: :delete_all
    field :name, :string, null: false
    field :place, :string, null: false
    field :start_date, :date, null: false
    field :end_date, :date, null: false
    field :confirmed, :boolean, null: false, default: false
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :name, :start_date, :end_date, :place, :confirmed])
    |> validate_required([:user_id, :name, :start_date, :end_date, :place, :confirmed])
  end
end
