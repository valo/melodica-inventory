defmodule MelodicaInventoryWeb.ItemControllerTest do
  use MelodicaInventoryWeb.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  describe "when not authorized" do
    test "show redirects to login", %{conn: conn} do
      response =
        conn
        |> get(item_path(conn, :show, 1))

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "new redirects to login", %{conn: conn} do
      response =
        conn
        |> get(item_path(conn, :new))

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "create redirects to login", %{conn: conn} do
      response =
        conn
        |> post(item_path(conn, :create), %{})

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when a user is authorized" do
    setup [:login_user]

    test "show renders the show item template", %{conn: conn} do
      item = insert(:item)

      response =
        conn
        |> get(item_path(conn, :show, item.id))

      refute response.resp_body =~ admin_item_path(conn, :edit, item.id)
      refute response.resp_body =~ admin_item_path(conn, :delete, item.id)
      assert response.resp_body =~ item.name
    end

    test "new renders the new item template", %{conn: conn} do
      variation = insert(:variation)

      response =
        conn
        |> get(item_path(conn, :new, %{"variation_id" => variation.id}))

      assert response.resp_body =~ "New item"
      assert response.resp_body =~ "Submit"
    end
  end

  describe "when an admin user is authorized" do
    setup [:login_user, :set_user_as_admin]

    test "show renders the items and allows editing them", %{conn: conn} do
      item = insert(:item)

      response =
        conn
        |> get(item_path(conn, :show, item.id))

      assert response.resp_body =~ admin_item_path(conn, :edit, item.id)
      assert response.resp_body =~ admin_item_path(conn, :delete, item.id)
      assert response.resp_body =~ item.name
    end
  end

  def login_user(_context) do
    current_user = insert(:user, admin: false)

    conn =
      build_conn()
      |> init_test_session(current_user: current_user.id)

    {:ok, conn: conn, current_user: current_user}
  end

  def set_user_as_admin(%{current_user: current_user} = context) do
    current_user =
      current_user
      |> change(admin: true)
      |> Repo.update!()

    %{context | current_user: current_user}
  end
end
