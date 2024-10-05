defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view

  alias Chat.Room
  alias Chat.Repo

  require Logger

  @impl true
  @spec mount(any, any, any) :: {:ok, any}
  def mount(_params, _session, socket) do
    room_list = Room |> Repo.all()
    # It's possible to deliver Struct directly, but you should set specific file to display it.
    {
      :ok,
      assign(
        socket,
        error: "",
        rooms: room_list,
        query: "",
        username: "",
        results: %{},
        username_form: to_form(%{}),
        form: to_form(%{})
      )
    }
  end


  def handle_event("set_username", %{"username" => username}, socket) do
    Logger.info("Setting username to #{username}")
    {:noreply, assign(socket, username: username, error: "")}
  end

  def handle_event("join_room", %{"room_id" => room_id}, socket) do
    username = socket.assigns.username
    case username do
      "" ->
        Logger.info("No username set")
        {:noreply, assign(socket, error: "no_username")}
      _ ->
        Logger.info("#{username} is joining the room:#{room_id}")
        {:noreply, push_redirect(socket, to: "/room/#{room_id}?username=#{username}")}
    end
  end

  # @impl true
  # def handle_event("validate", %{"room_name" => room_name}, socket) do
  #   form = %{room_name: room_name} |> to_form()
  #   {:noreply, assign(socket, form: form)}
  # end

  @impl true
  def handle_event("create_room", params, socket) do
    # store the room in the database
    Room.create_room(params["room_name"])
    |> case do
      {:ok, room} ->
        Logger.info("Room #{room.name} created successfully")
        room_url = "/room/" <> params["room.id"]
        {:noreply, push_redirect(socket, to: room_url)}
      {:error, changeset} ->
        Logger.info("Room #{params["room_name"]} could not be created: #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset), errors: changeset.errors)}
    end
  end

  def handle_event("error_handle_done", _params, socket) do
    Logger.info("Error handling done: #{inspect(socket.assigns)}")
    {:noreply, assign(socket, error: "")}
  end
end
