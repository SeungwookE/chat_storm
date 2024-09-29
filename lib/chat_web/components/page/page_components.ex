defmodule ChatWeb.PageComponents do
  use Phoenix.LiveComponent

  require Logger

  def room_list(assigns) do
    ~H"""
    <tr :for={room <- @rooms} >
      <td>
        <a href="#" phx-click="join_room" ><%= room %></a>
      </td>
    </tr>
    """
  end
end
