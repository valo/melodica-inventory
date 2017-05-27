defmodule MelodicaInventory.Web.EventView do
  use MelodicaInventory.Web, :view
  alias MelodicaInventory.Item

  def event_user(user) do
    user.first_name <> " " <> user.last_name
  end

  def format_date(datetime) do
    Timex.format!(datetime, "%d %b %Y", :strftime)
  end
end
