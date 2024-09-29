defmodule ChatWeb.ErrorHTML do
  use ChatWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/ChatWeb_web/controllers/error_html/404.html.heex
  #   * lib/ChatWeb_web/controllers/error_html/500.html.heex
  #
  # embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".

  embed_templates "error_html/*"

  def render(template, assigns) do
    Phoenix.Controller.status_message_from_template(template)
    # apply(__MODULE__, :"500", [assigns])
  end
end
