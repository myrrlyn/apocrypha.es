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
    # Discard posts that are not in a series
    |> Stream.filter(& &1.series)
    # Fold each post into its series bucket
    |> Enum.reduce(%{}, fn post, accum ->
      Map.update(accum, post.series, MapSet.new([post]), &MapSet.put(&1, post))
    end)
    # Convert each bucket into a date-sorted list
    |> par_map(fn {series, posts} -> {series, date_sorter(posts)} end)
    # Sort the buckets by first-entry publish date
    |> Enum.sort_by(&(&1 |> elem(1) |> Enum.at(0)).date, DateTime)
  end

  @doc """
  Clusters articles by their author.
  """
  @spec group_by_authors :: [{String.t(), posts()}]
  def group_by_authors() do
    snapshot_values()
    # Fold each post into its author bucket
    |> Enum.reduce(%{}, fn post, accum ->
      Map.update(accum, post.author, MapSet.new([post]), &MapSet.put(&1, post))
    end)
    # Convert each bucket into a date-sorted list
    |> par_map(fn {author, posts} -> {author, date_sorter(posts)} end)
    # Sort the buckets by author name, case-insensitively
    |> Enum.sort_by(&elem(&1, 0), &(String.downcase(&1) < String.downcase(&2)))
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

  defp date_sorter(posts), do: Enum.sort_by(posts, & &1.date, DateTime)

  defp par_map(stream, func) do
    stream
    |> Task.async_stream(func)
    |> Stream.filter(fn
      {:ok, _} -> true
      {:error, _} -> false
    end)
    |> Stream.map(&elem(&1, 1))
  end
end
