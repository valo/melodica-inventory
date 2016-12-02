defmodule MelodicaInventory.PageController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.TrelloBoard

  def index(conn, _params) do
    render conn, "index.html", boards: TrelloBoard.all
  end
end
