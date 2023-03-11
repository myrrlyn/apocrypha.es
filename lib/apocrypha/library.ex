defmodule Apocrypha.Library do
  @moduledoc """
  Caches post metadata only. Rendering a post still requires hitting the
  filesystem.
  """

  use Agent
  require Logger

  def start_link(init) do
    Agent.start_link(fn -> init end, name: __MODULE__)
  end

  def build_index() do
    snapshot = Agent.get(__MODULE__, & &1, :infinity) |> Map.keys() |> Enum.into(MapSet.new())

    public_posts()
    |> Stream.map(&Path.basename(&1, ".md"))
    |> Stream.filter(&(!MapSet.member?(snapshot, &1)))
    |> Task.async_stream(&load_post/1, timeout: :infinity)
    |> Stream.run()
  end

  def get_index() do
    Agent.get(__MODULE__, & &1, :infinity)
    |> Map.values()
    |> Enum.sort_by(& &1.reddit, &id_sorter/2)
  end

  def load_post(id) do
    case Apocrypha.Page.load_post("#{id}.md") do
      {:ok, %Apocrypha.Page{meta: meta}} ->
        Agent.update(__MODULE__, &Map.put(&1, id, meta))
        {:ok, id}

      {:error, error} ->
        {:error, id, error}
    end
  end

  def find_post(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  Gets the paths of all processed posts.
  """
  def public_posts() do
    glob_and_sort("archive")
  end

  @doc """
  Gets the paths of all posts awaiting processing.
  """
  def pending_posts() do
    glob_and_sort("pending")
  end

  defp glob_and_sort(folder) do
    Path.join(["priv", folder, "*.md"])
    |> Path.wildcard()
    |> Enum.sort(&id_sorter/2)
  end

  defp id_sorter(a, b) do
    len = max(String.length(a), String.length(b))
    String.pad_leading(a, len, "0") < String.pad_leading(b, len, "0")
  end
end
