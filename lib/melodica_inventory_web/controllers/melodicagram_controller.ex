defmodule MelodicaInventoryWeb.MelodicagramController do
  use MelodicaInventoryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
