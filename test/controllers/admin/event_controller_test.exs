defmodule MelodicaInventory.Admin.EventControllerTest do
  use MelodicaInventory.Web.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  describe "when not authorized" do
    test "new redirects to login", %{conn: conn} do
      response = conn
      |> get(admin_event_path(conn, :new))

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "new redirects to login if the user is not admin", %{conn: conn} do
      current_user = insert(:user, admin: false)

      conn = conn
      |> init_test_session(current_user: current_user.id)

      response = conn
      |> get(admin_event_path(conn, :new))

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when a user is authorized" do
    setup do
      current_user = insert(:user, admin: true)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, conn: conn, current_user: current_user}
    end

    test "new renders the form for createing a new event", %{conn: conn} do
      response = conn
      |> get(admin_event_path(conn, :new))

      assert response.resp_body =~ admin_event_path(conn, :create)
      assert response.resp_body =~ event_path(conn, :index)
    end
  end
end
