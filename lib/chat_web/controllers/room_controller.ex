defmodule ChatWeb.RoomController do
  use ChatWeb, :controller

  alias Chat.Repo
  alias Chat.Room
  alias ChatWeb.RoomLive
  alias ChatWeb.ErrorHTML

  require Logger

  def index(conn, params) do
    join_room(conn, params)
  end

  def join_room(conn, %{"room_id" => room_id, "username" => username} = _params) do
    with room <- Repo.get(Room, room_id),
      false <- username == "" do
        conn
        |> put_flash(:info, "You joined room #{room.name}")
        |> Phoenix.LiveView.Controller.live_render(RoomLive, session: %{
          "room_id" => room_id,
          "username" => username
        })
        # |> redirect(to: "/room/live/#{room_id}?username=#{username}")
    else
      _ ->
        # render ErrorHTML error page
        Logger.info("Error: Room #{room_id} not found")
        conn |> put_status(403) |> put_view(ErrorHTML) |> render(:"404")
    end
  end

  def join_room(conn, _params) do
    conn |> put_flash(:error, "Invalid room id") |> redirect(to: "/")
  end
end
