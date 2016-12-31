defmodule MelodicaInventory.ReturnLoanTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Item
  alias MelodicaInventory.Return
  alias MelodicaInventory.ReturnLoan

  import MelodicaInventory.Factory

  test "should fully return a valid loan and fulfil it" do
    loan = insert(:loan, quantity: 5)

    item_before = Repo.get!(Item, loan.item_id)

    {:ok, %{loan: loan, return: return}} = ReturnLoan.call(loan, loan.quantity, Return.returned)

    item_after = Repo.get!(Item, loan.item_id)

    assert return.type == Return.returned
    assert return.quantity == 5
    assert loan.fulfilled
    assert item_before.quantity + return.quantity == item_after.quantity
  end

  test "should partially return a valid loan and not fulfil it" do
    loan = insert(:loan, quantity: 5)

    item_before = Repo.get!(Item, loan.item_id)

    {:ok, %{loan: loan, return: return}} = ReturnLoan.call(loan, 4, Return.destroyed)

    item_after = Repo.get!(Item, loan.item_id)

    assert return.type == Return.destroyed
    assert return.quantity == 4
    assert !loan.fulfilled
    assert item_before.quantity + return.quantity == item_after.quantity
    assert loan.quantity == 1
  end
end
