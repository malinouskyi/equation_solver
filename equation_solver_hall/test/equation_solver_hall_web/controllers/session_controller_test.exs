defmodule EquationSolverHallWeb.SessionControllerTest do
  use EquationSolverHallWeb.ConnCase

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, session_path(conn, :new))

      assert html_response(conn, 200) =~ "Solve Equations"
    end
  end

  describe "create session" do
    test "adds user to session", %{conn: conn} do
      attrs = %{"name" => "Dima"}

      conn = post(conn, session_path(conn, :create), user: attrs)

      expected_user = %EquationSolver.User{name: "Dima"}

      assert Plug.Conn.get_session(conn, :current_user) == expected_user

      assert redirected_to(conn) == solver_path(conn, :new)
    end
  end

  describe "delete session" do
    test "deletes user from session", %{conn: conn} do
      conn = put_user_in_session(conn, "Dima")

      conn = delete(conn, session_path(conn, :delete))

      assert redirected_to(conn) == "/"

      assert Plug.Conn.get_session(conn, :current_user) == nil
    end
  end
end
