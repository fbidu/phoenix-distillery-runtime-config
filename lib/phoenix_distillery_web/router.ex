defmodule PhoenixDistilleryWeb.Router do
  use PhoenixDistilleryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixDistilleryWeb do
    pipe_through :api
    get "/", ConfigController, :config_check
  end
end
