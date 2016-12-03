defmodule MelodicaInventory.CategoryView do
  use MelodicaInventory.Web, :view
  alias MelodicaInventory.Item

  def cover_url(%Item{attachments: []}) do
    nil
  end

  def cover_url(%Item{attachments: attachments}) do
    List.first(attachments).url
  end
end
