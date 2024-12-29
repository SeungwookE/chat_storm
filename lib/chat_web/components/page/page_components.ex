defmodule ChatWeb.PageComponents do
  use Phoenix.LiveComponent

  require Logger

  def room_list(assigns) do
    ~H"""
    <tr :for={room <- @rooms}>
      <td>
        <a href="#" phx-click="join_room" phx-value-room_id={room.id}><%= room.name %></a>
      </td>
    </tr>
    """
  end
end
