defmodule ChatWeb.HelloController do
  use ChatWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
