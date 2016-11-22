defmodule MelodicaInventory.PageController do
  use MelodicaInventory.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", trello_key: Application.get_env(:trello, :api_key)
  end
end
