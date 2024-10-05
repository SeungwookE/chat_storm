defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  require Logger

  alias Chat.Repo
  alias Chat.Room

  # def mount(%{"room_id" => room_id, "username" => username}, _session, socket) do
  #   IO.puts("INSPECT mount1 from #{username}")
  #   {:ok, socket}
  # end

  @impl true
  def mount(%{"room_id" => room_id, "username" => username} = _params, _session, socket) do
    room = Repo.get(Room, room_id)
    topic = "room:" <> room.name
    # IO.puts("INSPECT mount from #{username} | #{inspect(socket, pretty: true, limit: 1000)}")

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic)
      ChatWeb.Presence.track(self(), topic, username, %{})
    end

    msg_input_form = to_form(%{"message" => ""}, as: :chat)

    {:ok,
      assign(socket,
        room_name: room.name,
        topic: topic,
        message: "",
        username: username,
        page_title: "ChatStorm:#{room.name}",
        messages: [],
        user_list: [],
        temporary_assigns: [messages: []],
        form: msg_input_form
      )}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    # clean up the message input form
    {:noreply, assign(socket, message: "")}
  end

  # phx-change will only can keep message value.
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    # Logger.info(message: socket.assigns)
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  # Handling joined user list by the pubsub event from Presence module
  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, uuid: UUID.uuid4(), content: "#{username} joined", username: "system"}
      end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, uuid: UUID.uuid4(), content: "#{username} left", username: "system"}
      end)

    user_list = ChatWeb.Presence.list(socket.assigns.topic) |> Map.keys()
    {:noreply, assign(
      socket,
      messages: join_messages ++ leave_messages,
      user_list: user_list
    )}
  end
end
