defmodule ChatWeb.PageComponents do
  use Phoenix.LiveComponent

  require Logger

  def room_list(assigns) do
    ~H"""
    <tr :for={room <- @room} >
      <td>
        <a href="#" phx-click="join_room" phx-value-room_name={room}><%= room %></a>
      </td>
    </tr>
    """
  end
end
