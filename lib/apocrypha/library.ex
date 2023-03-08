defmodule Apocrypha.Library do
  def public_posts() do
    Path.join(["priv", "archive", "*.md"]) |> Path.wildcard()
  end

  def pending_posts() do
    Path.join(["priv", "pending", "*.md"]) |> Path.wildcard()
  end
end
