defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view

  alias Chat.Room
  alias Chat.Repo

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    room_list = Room |> Repo.all() |> Enum.map(fn room -> room.name end)
    Logger.info("room_list: #{inspect(room_list)}")
    {:ok, assign(socket, room_list: room_list)}
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
    %Room{name: params["room_name"]}
    |> Repo.insert()

    room_url = "/" <> params["room_name"]
    {:noreply, push_redirect(socket, to: room_url)}
  end
end
