defmodule EquationSolverHallWeb.SolverView do
  use EquationSolverHallWeb, :view

  @spec current_solver_url(
          atom
          | %{__struct__: Phoenix.Socket | Plug.Conn | URI, request_path: binary}
        ) :: binary
  def current_solver_url(conn) do
    url(conn) <> conn.request_path
  end

  def ws_url do
    System.get_env("WS_URL") || EquationSolverHallWeb.Endpoint.config(:ws_url)
  end
end
