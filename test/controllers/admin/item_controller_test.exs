defmodule MelodicaInventory.Admin.ItemControllerTest do
  use MelodicaInventoryWeb.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  alias MelodicaInventory.Goods.{Variation, Item}

  describe "when not authorized" do
    setup [:login_user]

    test "edit redirects to login", %{conn: conn} do
      response = conn
      |> get(admin_item_path(conn, :edit, 1))

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "upadte redirects to login", %{conn: conn} do
      response = conn
      |> put(admin_item_path(conn, :update, 1), %{})

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "delete redirects to login", %{conn: conn} do
      response = conn
      |> delete(admin_item_path(conn, :delete, 1))

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when an admin user is authorized" do
    setup [:login_user, :set_user_as_admin]

    test "edit renders the items and allows editing them", %{conn: conn} do
      item = insert(:item)
      variation = Repo.get!(Variation, item.variation_id)

      response = conn
      |> get(admin_item_path(conn, :edit, item.id))

      assert response.resp_body =~ category_path(conn, :show, variation.category_id)
      assert response.resp_body =~ item.name
    end

    test "update updates the items and goes to the category path", %{conn: conn} do
      item = insert(:item, name: "Test")
      variation = Repo.get!(Variation, item.variation_id)

      response = conn
      |> put(admin_item_path(conn, :update, item.id), %{"item" => %{"name" => "Updated test name"}})

      assert redirected_to(response) =~ category_path(conn, :show, variation.category_id)
      assert Repo.get!(Item, item.id).name == "Updated test name"
    end

    test "delete removes the item and redirects to the category path", %{conn: conn} do
      item = insert(:item, name: "Test")
      variation = Repo.get!(Variation, item.variation_id)

      response = conn
      |> delete(admin_item_path(conn, :delete, item.id))

      assert redirected_to(response) =~ category_path(conn, :show, variation.category_id)
      assert Repo.get(Item, item.id) == nil
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
