defmodule Whiteprint.PageController do
  use Whiteprint.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
