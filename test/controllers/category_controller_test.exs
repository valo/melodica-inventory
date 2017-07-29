defmodule MelodicaInventory.CategoryControllerTest do
  use MelodicaInventoryWeb.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  describe "when not authorized" do
    test "index redirects to login", %{conn: conn} do
      response = conn
      |> get(category_path(conn, :index))

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when a user is authorized" do
    setup do
      current_user = insert(:user)
      category = insert(:category)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, conn: conn, current_user: current_user, category: category}
    end

    test "index renders the categories", %{conn: conn, category: category} do
      response = conn
      |> get(category_path(conn, :index))

      assert response.resp_body =~ "Categories"
      assert response.resp_body =~ category.name
      refute response.resp_body =~ "Delete"
    end
  end

  describe "when an admin user is authorized" do
    setup do
      current_user = insert(:user, admin: true)
      category = insert(:category)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, conn: conn, current_user: current_user, category: category}
    end

    test "index renders the categories", %{conn: conn, category: category} do
      response = conn
      |> get(category_path(conn, :index))

      assert response.resp_body =~ "Categories"
      assert response.resp_body =~ category.name
    end
  end
end
