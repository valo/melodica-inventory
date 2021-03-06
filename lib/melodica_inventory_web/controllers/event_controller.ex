defmodule MelodicaInventoryWeb.EventController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.Event
  alias MelodicaInventory.Accounts.User

  def show(conn, %{"id" => id}) do
    event =
      Repo.get!(Event, id)
      |> Repo.preload(item_reservations: :item)

    render(conn, "show.html", event: event)
  end

  def index(conn, _) do
    events =
      Event
      |> where([e], is_nil(e.archived_at))
      |> order_by([e], desc: e.start_date)
      |> Repo.all()
      |> Repo.preload([:user])

    render(conn, "index.html", events: events)
  end

  def new(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _) do
    changeset = Event.changeset(%Event{user_id: current_user.id})

    render(conn, "new.html", changeset: changeset, users: Repo.all(User))
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, users: Repo.all(User))
    end
  end
end
