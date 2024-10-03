defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  require Logger

  alias Chat.Repo
  alias Chat.Room

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    room = Repo.get(Room, room_id)
    topic = "room:" <> room.name
    username = MnemonicSlugs.generate_slug(2)
    if connected?(socket), do: ChatWeb.Endpoint.subscribe(topic)

    {:ok,
      assign(socket,
        room_name: room.name,
        topic: topic,
        username: username,
        message: "",
        messages: [%{uuid: UUID.uuid4(), content: "#{username} joined the chat"}],
        temporary_assigns: [messages: []],
        form: to_form(%{"message" => ""})
      )}
  end

  @impl true
  @spec handle_event(<<_::88, _::_*24>>, map(), any()) :: {:noreply, any()}
  def handle_event("submit_message", %{"message" => message}, socket) do
    message = %{uuid: UUID.uuid4(), content: message}
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "")}
  end

  # def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
  #   Logger.info(message: message)
  #   {:noreply, assign(socket, message: message)}
  # end

  @impl true
  @spec handle_info(%{:event => <<_::88>>, :payload => any(), optional(any()) => any()}, any()) ::
          {:noreply, any()}
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end
end
