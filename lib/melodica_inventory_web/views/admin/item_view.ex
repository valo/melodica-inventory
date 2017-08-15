defmodule MelodicaInventoryWeb.Admin.ItemView do
  use MelodicaInventoryWeb, :view

  alias MelodicaInventory.Goods.Item
  alias Cloudex.Url
  import MelodicaInventoryWeb.ItemView, only: [cover_urls: 1]
end
