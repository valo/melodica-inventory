defmodule MelodicaInventoryWeb.Admin.ItemImagesController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.ImageOperations

  def delete(conn, %{"images" => images, "item_id" => item_id}) do
    ImageOperations.delete_images(images)
    redirect(conn, to: item_path(conn, :show, item_id))
  end
end
