defmodule MelodicaInventory.CategoryControllerTest do
  use MelodicaInventory.Web.ConnCase, async: true

  import MelodicaInventory.Factory

  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt",
    log: false
  ]
  @secret String.duplicate("abcdef0123456789", 8)
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

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

      conn = put_in(conn.secret_key_base, @secret)
      |> Plug.Session.call(@signing_opts)
      |> fetch_session
      |> put_session(:current_user, current_user.id)

      {:ok, conn: conn, current_user: current_user, category: category}
    end

    test "index renders the categories", %{conn: conn, category: category} do
      response = conn
      |> get(category_path(conn, :index))

      assert response.resp_body =~ "Categories"
      assert response.resp_body =~ category.name
      refute response.resp_body =~ "Events"
    end
  end

  describe "when an admin user is authorized" do
    setup do
      current_user = insert(:user, admin: true)
      category = insert(:category)

      conn = build_conn()

      conn = put_in(conn.secret_key_base, @secret)
      |> Plug.Session.call(@signing_opts)
      |> fetch_session
      |> put_session(:current_user, current_user.id)

      {:ok, conn: conn, current_user: current_user, category: category}
    end

    test "index renders the categories", %{conn: conn, category: category} do
      response = conn
      |> get(category_path(conn, :index))

      assert response.resp_body =~ "Categories"
      assert response.resp_body =~ category.name
      assert response.resp_body =~ "Events"
    end
  end
end
