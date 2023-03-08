defmodule Apocrypha.Library do
  def public_posts() do
    glob_and_sort("archive")
  end

  def pending_posts() do
    glob_and_sort("pending")
  end

  defp glob_and_sort(folder) do
    Path.join(["priv", folder, "*.md"])
    |> Path.wildcard()
    |> Enum.sort(fn a, b ->
      len = max(String.length(a), String.length(b))
      String.pad_leading(a, len, "0") < String.pad_leading(b, len, "0")
    end)
  end
end
