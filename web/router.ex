defmodule Mutombofon.Router do
  use Mutombofon.Web, :router

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

  scope "/", Mutombofon do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/list", PageController, :list
    get "/upload", PageController, :upload
    post "/fileupload", PageController, :fileupload
    post "/play", PageController, :play
  end

  # Other scopes may use custom stacks.
  # scope "/api", Mutombofon do
  #   pipe_through :api
  # end
end
