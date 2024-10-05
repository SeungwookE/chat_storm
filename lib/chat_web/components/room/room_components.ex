defmodule ChatWeb.RoomComponents do
  use Phoenix.Component

  require Logger

  attr :messages, :any, required: false
  def display_messages(assigns) do
    ~H"""
      <%= for message <- @messages do %>
        <p id={message.uuid}>
          <%= if Map.has_key?(message, :type) && message.type == :system do %>
            <div><em><%= message.content%></em></div>
          <% else %>
            <div class="text-sm text-zinc-500 my-1 font-extralight"><strong><%= message.username%></strong></div>
            <div class="px-2 flex">
              <div class="px-2 py-0.5 border rounded-lg"><%= message.content %></div>
            </div>
          <% end %>
        </p>
      <% end %>
    """
  end
end
