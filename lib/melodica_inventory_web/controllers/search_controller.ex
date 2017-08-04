defmodule MelodicaInventoryWeb.SearchController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.Item

  def index(conn, %{ "q" => query }) do
    query_with_wildcards = "%#{query}%"

    items = (from i in Item, where: ilike(i.name, ^query_with_wildcards), limit: 10)
    |> preload([:images, :attachments])
    |> Repo.all

    conn
    |> put_layout(false)
    |> render("index.html", items: items)
  end
end
