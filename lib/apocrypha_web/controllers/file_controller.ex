defmodule ApocryphaWeb.FileController do
  use ApocryphaWeb, :controller

  def well_known(conn, %{"file" => filename}) do
    send_file(conn, 200, Path.join([".well-known" | filename]))
  end
end
