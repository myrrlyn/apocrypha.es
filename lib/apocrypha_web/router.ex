defmodule ApocryphaWeb.Router do
  use ApocryphaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApocryphaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/.well-known", ApocryphaWeb do
    get "/*file", FileController, :well_known
  end

  # Processed Apocrypha
  scope "/a", ApocryphaWeb do
    pipe_through :browser

    get "/", PageController, :articles
    get "/:id", PageController, :article
    get "/:id/:asset", PageController, :asset
  end

  # Queue for processing
  scope "/q", ApocryphaWeb do
    pipe_through :browser

    get "/", PageController, :draft_articles
    get "/:id", PageController, :draft_article
    get "/:id/:asset", PageController, :draft_asset
  end

  # Group posts by series
  scope "/s", ApocryphaWeb do
    pipe_through :browser

    get "/", PageController, :all_series
  end

  # Group posts by user
  scope "/u", ApocryphaWeb do
    pipe_through :browser

    get "/", PageController, :all_authors
    get "/:user", PageController, :author_page
  end

  scope "/", ApocryphaWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/random", PageController, :random
    get "/style", PageController, :style
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApocryphaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:apocrypha, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ApocryphaWeb.Telemetry
    end
  end
end
