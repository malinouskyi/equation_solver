defmodule EquationSolverHallWeb.Router do
  use EquationSolverHallWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EquationSolverHallWeb do
    pipe_through :browser # Use the default browser stack

    get "/", SolverController, :new

    resources "/solvers", SolverController,
                        only: [:new, :create, :show]

    resources "/sessions", SessionController,
                           only: [:new, :create, :delete],                      singleton: true

  end

  # Other scopes may use custom stacks.
  # scope "/api", EquationSolverHallWeb do
  #   pipe_through :api
  # end
end
