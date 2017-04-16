Borrowing items:
* deadline - next monday

Admin:
* Allow to return borrowed item
  * Specify number of items returned
  * Allow to set borrowed items as destroyed - remove the quantity from the total amount
* Spreadsheet to set availability of all items
* Delete item
* Sync data from trello on a regular basis - each day

Future:

Booking items:
* Bookings belong to an Event
* Event
  * Date, name, place, confirmed (yes/no), belongs to a user
  * Dropdown to select an event in the header
  * New event button in the header
  * Convert a set of bookings to loans - multiple select of bookings to Convert
  * Convert unavailable items to loans by transferring between users
    * 1. Select an unavailable item
    * 2. Select number to borrow from each user that has the item
    * 3. Confirm transfer
* Allow to book item for a future period - user specifies start-end date
* Allow to see booked items for a given date
* Allow to edit a booked item - from the list of items you can change the booked
* Allow to borrow a booked item
* Allow to see availability of items for a given date
* Item state:
  * Booking confirmed/not confirmed for a date
  * Orange
    * confirmed/not confirmed for the period
  * Red
    * confirmed for the event date
  * Green - free to book


  defmodule MelodicaInventory.Event do
    use MelodicaInventory.Web, :model
    alias MelodicaInventory.User
    alias MelodicaInventory.Item
    alias MelodicaInventory.Return

    schema "loans" do
      belongs_to :user, User
      has_many :items, Item
      field :name
      field :start_date, :datetime, null: false
      field :end_date, :datetime, null: false
      field :place, :string, null: false

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
