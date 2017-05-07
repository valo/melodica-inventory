defmodule MelodicaInventory.Admin.VariationControllerTest do
  use MelodicaInventory.Web.ConnCase, async: false

  alias MelodicaInventory.Variation
  alias MelodicaInventory.Repo

  import MelodicaInventory.Factory
  import Plug.Test

  describe "without a logged in user" do
    test "the edit page redirects to login", %{conn: conn} do
      variation = insert(:variation)

      response = conn
      |> get(admin_variation_path(conn, :edit, variation))

      assert redirected_to(response) == login_path(conn, :index)
    end

    test "the new page redirects to login", %{conn: conn} do
      category = insert(:category)

      response = conn
      |> get(admin_variation_path(conn, :new, category_id: category.id))

      assert redirected_to(response) == login_path(conn, :index)
    end

    test "create redirects to login", %{conn: conn} do
      insert(:category)

      response = conn
      |> post(admin_variation_path(conn, :create, variation: %{}))

      assert redirected_to(response) == login_path(conn, :index)
    end

    test "delete redirects to login", %{conn: conn} do
      variation = insert(:variation)

      response = conn
      |> delete(admin_variation_path(conn, :delete, variation.id))

      assert redirected_to(response) == login_path(conn, :index)
    end
  end

  describe "with a logged in admin user" do
    setup do
      current_user = insert(:user, admin: true)

      conn = build_conn()
      |> init_test_session(current_user: current_user.id)

      {:ok, %{current_user: current_user, conn: conn}}
    end

    test "the edit page renders the edit template", %{conn: conn} do
      variation = insert(:variation)

      response = conn
      |> get(admin_variation_path(conn, :edit, variation))

      assert response.resp_body =~ "Edit #{variation.name}"
      assert response.resp_body =~ admin_variation_path(conn, :update, variation.id)
    end

    test "the update action changes the variation", %{conn: conn} do
      variation = insert(:variation)

      response = conn
      |> put(
        admin_variation_path(conn, :update, variation.id),
        %{"variation" => %{"name" => "Updated name"}}
      )

      assert redirected_to(response) == category_path(conn, :show, variation.category_id)
    end

    test "the new page renders the new template", %{conn: conn} do
      category = insert(:category)

      response = conn
      |> get(admin_variation_path(conn, :new, category_id: category.id))

      assert response.resp_body =~ "New Variation"
      assert response.resp_body =~ admin_variation_path(conn, :create)
    end

    test "delete deletes the variation and redirect to the category", %{conn: conn} do
      variation = insert(:variation)
      item = insert(:item, variation: variation, quantity: 1)
      loan = insert(:loan, item: item, quantity: 1)

      response = conn
      |> delete(admin_variation_path(conn, :delete, variation.id))

      assert redirected_to(response) == category_path(conn, :show, variation.category_id)
      assert Repo.get(Variation, variation.id) == nil
    end
  end
end
