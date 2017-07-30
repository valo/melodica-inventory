defmodule MelodicaInventoryWeb.Admin.LoanControllerTest do
  use MelodicaInventoryWeb.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  alias MelodicaInventory.Goods.Item

  describe "when not authorized" do
    setup [:login_user]

    test "index redirects to login", %{conn: conn} do
      response = conn
      |> get(admin_loan_path(conn, :index))

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when an admin user is authorized" do
    setup [:login_user, :set_user_as_admin]

    test "index renders all the loans", %{conn: conn} do
      loan = insert(:loan)
      item = Repo.get!(Item, loan.item_id)

      response = conn
      |> get(admin_loan_path(conn, :index))

      assert response.resp_body =~ item.name
    end

    test "index filters the loans by name", %{conn: conn} do
      loan = insert(:loan)
      item = Repo.get!(Item, loan.item_id)

      response = conn
      |> get(admin_loan_path(conn, :index), %{"filters" => %{"name" => item.name, "user_id" => ""}})

      assert response.resp_body =~ item.name

      response = conn
      |> get(admin_loan_path(conn, :index), %{"filters" => %{"name" => "Random non-existing name", "user_id" => ""}})

      refute response.resp_body =~ item.name
    end

    test "index filters the loans by user_id", %{conn: conn} do
      loan = insert(:loan)
      item = Repo.get!(Item, loan.item_id)

      response = conn
      |> get(admin_loan_path(conn, :index), %{"filters" => %{"name" => "", "user_id" => Integer.to_string(loan.user_id)}})

      assert response.resp_body =~ item.name

      response = conn
      |> get(admin_loan_path(conn, :index), %{"filters" => %{"name" => "", "user_id" => "99999"}})

      refute response.resp_body =~ item.name
    end
  end

  def login_user(_context) do
    current_user = insert(:user, admin: false)

    conn = build_conn()
    |> init_test_session(current_user: current_user.id)

    {:ok, conn: conn, current_user: current_user}
  end

  def set_user_as_admin(%{current_user: current_user} = context) do
    current_user = current_user
    |> change(admin: true)
    |> Repo.update!

    %{context | current_user: current_user}
  end
end
