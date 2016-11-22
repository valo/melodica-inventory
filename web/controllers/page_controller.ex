defmodule MelodicaInventory.PageController do
  use MelodicaInventory.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
