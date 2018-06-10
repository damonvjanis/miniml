defmodule MinimlWeb.Router do
  use MinimlWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/api", MinimlWeb do
    pipe_through :api

    resources "/requests", RequestController, only: [:create, :show]
    get "/requests", RequestController, :show_by_minified
  end
end
