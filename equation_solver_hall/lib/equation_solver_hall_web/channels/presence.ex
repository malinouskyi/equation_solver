defmodule EquationSolverHallWeb.Presence do
  use Phoenix.Presence,
    otp_app: :equation_solver_hall,
    pubsub_server: EquationSolverHall.PubSub
end
