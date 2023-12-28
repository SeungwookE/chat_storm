defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{}, form: to_form(%{}))}
  end

  # handle_params, render functions omitted

  @impl true
  def handle_event("validate", %{"room_name" => room_name}, socket) do
    form = %{room_name: room_name} |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("create", params, socket) do
    Logger.info("INSPECT params: #{inspect(params)})}")
    room_url = "/" <> params["room_name"]
    {:noreply, push_redirect(socket, to: room_url)}
  end
end
