defmodule MelodicaInventory.CreateLoanTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Item
  alias MelodicaInventory.CreateLoan

  import MelodicaInventory.Factory

  test "should create a loan for a valid item and user" do
    user = insert(:user)
    item = insert(:item, quantity: 5)

    {:ok, loan} = CreateLoan.call(item, user, 5)

    item = Repo.get!(Item, item.id)

    assert loan.quantity == 5
    assert !loan.fulfilled
    assert item.quantity == 0
  end

  test "should not create a loan for an item with too less items" do
    user = insert(:user)
    item = insert(:item, quantity: 1)

    assert_raise Postgrex.Error, fn ->
      CreateLoan.call(item, user, 5) == {:error}
    end
  end
end
