defmodule MelodicaInventory.CreateLoanTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Item
  alias MelodicaInventory.CreateLoan

  import MelodicaInventory.Factory

  test "should create a loan for a valid item and user" do
    user = insert(:user)
    item = insert(:item, quantity: 5)

    {:ok, %{loan: loan}} = CreateLoan.call(item, user, 5)

    item = Repo.get!(Item, item.id)

    assert loan.quantity == 5
    assert !loan.fulfilled
    assert item.quantity == 0
  end

  test "should not create a loan for an item with too less items" do
    user = insert(:user)
    item = insert(:item, quantity: 1)

    {:error, failed_value} = CreateLoan.call(item, user, 5)

    assert Keyword.keys(failed_value.errors) == [:quantity]
    assert failed_value.action == :insert
  end

  test "building the loan from a reservation" do
    user = insert(:user)
    item = insert(:item, quantity: 10)
    reservation = insert(:item_reservation, quantity: 10, item: item)

    {:ok, %{loan: loan}} = Repo.transaction(CreateLoan.build_from_reservation(reservation, user))

    item = Repo.get!(Item, item.id)

    assert item.quantity == 0
    assert loan.quantity == 10
    assert loan.user_id == user.id
  end
end
