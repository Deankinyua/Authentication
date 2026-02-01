defmodule AuthenticationWeb.PageController do
  use AuthenticationWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
