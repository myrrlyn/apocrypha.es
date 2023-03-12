defmodule Apocrypha.Library do
  @moduledoc """
  Caches post metadata only. Rendering a post still requires hitting the
  filesystem.
  """

  use Agent
  require Logger
  alias Apocrypha.Frontmatter

  @typedoc """
  A flat sequence of posts, sorted by publication date.
  """
  @type posts :: [Frontmatter.post()]

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
    snapshot = snapshot() |> Map.keys() |> MapSet.new()

    public_posts()
    |> Stream.map(&Path.basename(&1, ".md"))
    |> Stream.filter(&(!MapSet.member?(snapshot, &1)))
    |> Task.async_stream(&load_post/1, timeout: :infinity)
    |> Stream.run()
  end

  @doc """
  Gets a flat list of all metadata objects in the store
  """
  @spec get_index :: posts()
  def get_index() do
    snapshot_values() |> Enum.sort_by(& &1.reddit, &id_sorter/2)
  end

  @doc """
  Clusters posts that are members of a series by that series.

  Posts that do not define a `series:` tag in their frontmatter are excluded
  from this listing.
  """
  @spec group_by_series :: [{String.t(), posts()}]
  def group_by_series() do
    snapshot_values()
    |> Stream.filter(&(&1.series))
    |> Enum.reduce(%{}, fn post, accum ->
      Map.update(accum, post.series, MapSet.new([post]), &MapSet.put(&1, post))
    end)
    |> Stream.map(fn {series, posts} -> {series, Enum.sort_by(posts, & &1.date, DateTime)} end)
    |> Enum.sort_by(fn {_, posts} -> Enum.at(posts, 0).date end, DateTime)
  end

  @doc """
  Clusters articles by their author.
  """
  @spec group_by_authors :: [{String.t(), posts()}]
  def group_by_authors() do
    snapshot_values()
    |> Enum.reduce(%{}, fn post, accum ->
      Map.update(accum, post.author, MapSet.new([post]), & MapSet.put(&1, post))
    end)
    |> Stream.map(fn {author, posts} -> {author, Enum.sort_by(posts, & &1.date, DateTime)} end)
    |> Enum.sort_by(&elem(&1, 0))
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
