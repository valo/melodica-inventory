defmodule MelodicaInventory.Goods.Event do
  @moduledoc false

  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Accounts.User
  alias MelodicaInventory.Loans.ItemReservation

  schema "events" do
    belongs_to(:user, User)
    has_many(:item_reservations, ItemReservation, on_delete: :delete_all)
    field(:name, :string, null: false)
    field(:place, :string, null: false)
    field(:start_date, :date, null: false)
    field(:end_date, :date, null: false)
    field(:confirmed, :boolean, null: false, default: false)
    field(:archived_at, :utc_datetime, default: nil)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :name, :start_date, :end_date, :place, :confirmed])
    |> validate_required([:user_id, :name, :start_date, :end_date, :place, :confirmed])
    |> validate_start_end_dates
  end

  defp validate_start_end_dates(changeset) do
    with start_date <- get_field(changeset, :start_date),
         end_date <- get_field(changeset, :end_date),
         true <- start_date != nil and end_date != nil,
         :gt <- Date.compare(start_date, end_date) do
      add_error(changeset, :date, "End date can't be before the start date")
    else
      _ -> changeset
    end
  end
end
