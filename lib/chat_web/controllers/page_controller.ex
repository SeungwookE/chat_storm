defmodule ChatWeb.PageController do
  use ChatWeb, :controller

  alias Chat.Repo
  alias Chat.Room
  alias ChatWeb.ErrorHTML

  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def join_room(conn, %{"room_id" => room_id} = _params) do
    Logger.info("Joining room #{room_id}")
    case Repo.get(Room, room_id) do
      nil ->
        # render ErrorHTML error page
        Logger.info("Error: Room #{room_id} not found")
        conn |> put_status(403) |> put_view(ErrorHTML) |> render(:"404")
      room ->
        conn
        |> put_flash(:info, "You joined room #{room.name}")
        |> redirect(to: "/room/live/#{room_id}")
    end
  end
end
