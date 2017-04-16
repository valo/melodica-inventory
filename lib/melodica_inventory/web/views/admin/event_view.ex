defmodule MelodicaInventory.Web.Admin.EventView do
  use MelodicaInventory.Web, :view

  def event_user(user) do
    user.first_name <> " " <> user.last_name
  end

  def format_date(datetime) do
    Timex.format!(datetime, "%Y-%m-%d", :strftime)
  end
end
