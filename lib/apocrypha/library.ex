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

  @doc """
  Builds the in-memory metadata collection.

  This does not update any keys that are already in the store; it only loads
  files whose ID is missing. It is not going to be useful in production, where
  the post collection does not change, but is a convenience during development.
  """
  def build_index() do
    snapshot = snapshot() |> Map.keys() |> Enum.into(MapSet.new())

    public_posts()
    |> Stream.map(&Path.basename(&1, ".md"))
    |> Stream.filter(&(!MapSet.member?(snapshot, &1)))
    |> Task.async_stream(&load_post/1, timeout: :infinity)
    |> Stream.run()
  end

  @doc """
  Gets a list of all metadata objects in the store, sorted by publication date.
  """
  @spec get_index :: [Apocrypha.Frontmatter.post()]
  def get_index() do
    snapshot_values() |> Enum.sort_by(& &1.reddit, &id_sorter/2)
  end

  @doc """
  Gets a collection of all recognized `series:` names in the published set.
  """
  @spec all_series :: MapSet.t(String.t())
  def all_series() do
    snapshot_values() |> Stream.map(& &1.series) |> Stream.filter(& &1) |> Enum.into(MapSet.new())
  end

  @doc """
  Gets a all of the posts contained in a given series.
  """
  @spec get_series(String.t()) :: [Apocrypha.Frontmatter.post()]
  def get_series(series_name) do
    snapshot_values()
    |> Stream.filter(&(&1.series == series_name))
    |> Enum.sort_by(& (&1.part || &1.date))
  end

  @doc """
  Loads a single post from `priv/archive/`.
  """
  def load_post(id) do
    case Apocrypha.Page.load_post("#{id}.md") do
      {:ok, %Apocrypha.Page{meta: meta}} ->
        Agent.update(__MODULE__, &Map.put(&1, id, meta))
        {:ok, id}

      {:error, error} ->
        {:error, id, error}
    end
  end

  @doc """
  Looks up the cached metadata for a given `priv/archive/` post.
  """
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

  defp snapshot(), do: Agent.get(__MODULE__, & &1, :infinity)

  defp snapshot_values(), do: snapshot() |> Stream.map(&elem(&1, 1))
end
