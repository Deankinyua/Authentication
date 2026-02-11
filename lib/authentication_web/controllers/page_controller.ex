defmodule AuthenticationWeb.PageController do
  use AuthenticationWeb, :controller

  def home(conn, _params) do
    render(assign(conn, :current_url, ~p"/"), :home)
  end
end
