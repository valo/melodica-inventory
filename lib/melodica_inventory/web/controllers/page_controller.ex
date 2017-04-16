defmodule MelodicaInventory.Web.PageController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Category

  def index(conn, _params) do
    render conn, "index.html", categories: Repo.all(Category)
  end
end
