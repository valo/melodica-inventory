defmodule MelodicaInventoryWeb.Admin.EventController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Event
  alias MelodicaInventory.User

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Event, id)
    |> Event.changeset

    render conn, "edit.html", changeset: changeset, users: Repo.all(User)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    changeset = Repo.get!(Event, id)
    |> Event.changeset(event_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    Repo.delete!(event)

    redirect(conn, to: event_path(conn, :index))
  end
end
