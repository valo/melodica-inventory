defmodule MelodicaInventoryWeb.Admin.EventArchiveController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.Event
  alias MelodicaInventory.Accounts.User

  def index(conn, _) do
    events =
      Event
      |> where([e], not is_nil(e.archived_at))
      |> order_by([e], desc: e.start_date)
      |> Repo.all()
      |> Repo.preload([:user])

    render(conn, "index.html", events: events)
  end

  def create(conn, %{"id" => id}) do
    changeset =
      Repo.get!(Event, id)
      |> Ecto.Changeset.change(archived_at: DateTime.truncate(DateTime.utc_now(), :second))

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event archived")
        |> redirect(to: event_path(conn, :index))

      {:error, error} ->
        conn
        |> put_flash(:error, "Error archiving event: #{error}")
        |> redirect(to: event_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    changeset =
      Repo.get!(Event, id)
      |> Ecto.Changeset.change(archived_at: nil)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event unarchived")
        |> redirect(to: event_path(conn, :index))

      {:error, error} ->
        conn
        |> put_flash(:error, "Error unarchiving event: #{error}")
        |> redirect(to: event_path(conn, :index))
    end
  end
end
