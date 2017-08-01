defmodule MelodicaInventoryWeb.EventControllerTest do
  use MelodicaInventoryWeb.ConnCase, async: false

  import MelodicaInventory.Factory
  import Plug.Test

  describe "when not authorized" do
    test "index redirects to login", %{conn: conn} do
      response = conn
      |> get(event_path(conn, :index))

      assert redirected_to(response) =~ login_path(conn, :index)
    end

    test "new redirects to login", %{conn: conn} do
      response = conn
      |> get(event_path(conn, :new))

      assert redirected_to(response) =~ login_path(conn, :index)
    end
  end

  describe "when a user is authorized" do
    setup do
      current_user = insert(:user)
      event = insert(:event)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, conn: conn, current_user: current_user, event: event}
    end

    test "new renders the form for createing a new event", %{conn: conn} do
      response = conn
      |> get(event_path(conn, :new))

      assert response.resp_body =~ event_path(conn, :create)
      assert response.resp_body =~ event_path(conn, :index)
    end

    test "index renders the events", %{conn: conn, event: event} do
      response = conn
      |> get(event_path(conn, :index))

      assert response.resp_body =~ event_path(conn, :new)
      refute response.resp_body =~ admin_event_path(conn, :edit, event.id)
      refute response.resp_body =~ admin_event_path(conn, :delete, event.id)
      assert response.resp_body =~ event.name
    end
  end

  describe "when an admin user is authorized" do
    setup do
      current_user = insert(:user, admin: true)
      event = insert(:event)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, conn: conn, current_user: current_user, event: event}
    end

    test "index renders the events and allows editing them", %{conn: conn, event: event} do
      response = conn
      |> get(event_path(conn, :index))

      assert response.resp_body =~ event_path(conn, :new)
      assert response.resp_body =~ admin_event_path(conn, :edit, event.id)
      assert response.resp_body =~ admin_event_path(conn, :delete, event.id)
      assert response.resp_body =~ event.name
    end
  end
end
