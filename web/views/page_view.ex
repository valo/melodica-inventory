defmodule MelodicaInventory.PageView do
  use MelodicaInventory.Web, :view

  def chunked_boards(boards) do
    Enum.chunk(boards, 4, 4, [])
  end
end
