defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view

  alias Chat.Room
  alias Chat.Repo

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    room_list = Room |> Repo.all() |> Enum.map(fn room -> room.name end)
    {:ok, assign(socket, query: "", results: %{room_list: room_list}, form: to_form(%{}))}
  end

  # render functions omitted

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
        room_url = "/" <> params["room_name"]
        {:noreply, push_redirect(socket, to: room_url)}
      {:error, changeset} ->
        Logger.info("Room #{params["room_name"]} could not be created")
        {:noreply, assign(socket, form: to_form(changeset), errors: changeset.errors)}
    end
  end
end
