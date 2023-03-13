defmodule ApocryphaWeb.Components do
  use Phoenix.Component
  use ApocryphaWeb, :verified_routes

  embed_templates "components/*"
end
