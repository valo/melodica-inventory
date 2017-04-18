defmodule MelodicaInventory.AuthControllerTest do
  use MelodicaInventory.Web.ConnCase, async: true

  test "index renders index.html", %{conn: conn} do
    response = conn
    |> get(login_path(conn, :index))

    assert response.resp_body =~ "Login with Google"
    refute response.resp_body =~ "Categories"
  end
end
