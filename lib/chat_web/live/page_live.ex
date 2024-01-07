defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view

  alias Chat.Room
  alias Chat.Repo

  require Logger

  @impl true
  @spec mount(any, any, any) :: {:ok, any}
  def mount(_params, _session, socket) do
    room_list = Room |> Repo.all() |> Enum.map(fn room -> room.name end)
    Logger.info("Room list: #{inspect(room_list)}")
    {:ok, assign(socket, rooms: room_list, query: "", results: %{}, form: to_form(%{}))}
  end

  # render functions omitted

  def handle_event("join_room", %{"room_name" => room_name}, socket) do
    Logger.info("Joining room #{room_name}")
    {:noreply, push_redirect(socket, to: "/room/#{room_name}")}
  end

  @impl true
  def handle_event("validate", %{"room_name" => room_name}, socket) do
    form = %{room_name: room_name} |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("create", params, socket) do
    # store the room in the database
    Room.create_room(params["room_name"])
    |> case do
      {:ok, room} ->
        Logger.info("Room #{room.name} created successfully")
        room_url = "/room/" <> params["room_name"]
        {:noreply, push_redirect(socket, to: room_url)}
      {:error, changeset} ->
        Logger.info("Room #{params["room_name"]} could not be created")
        {:noreply, assign(socket, form: to_form(changeset), errors: changeset.errors)}
    end
  end
end
