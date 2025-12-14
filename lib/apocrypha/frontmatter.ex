defmodule Apocrypha.Frontmatter.Page do
  @moduledoc """
  YAML frontmatter for ordinary site pages.
  """

  @behaviour Access

  defstruct [:title, :tab_title, {:rest, %{}}]

  @type t :: %__MODULE__{title: String.t(), tab_title: String.t() | nil}

  def new(map) do
    {title, map} = Map.pop!(map, "title")
    {tab_title, map} = Map.pop(map, "tab_title")

    %__MODULE__{
      title: title,
      tab_title: tab_title,
      rest: map
    }
  end

  @impl Access
  def fetch(this, key) do
    this = Map.from_struct(this)
    key = to_string(key)
    {:ok, this[key] || this.rest[key]}
  end
end

defmodule Apocrypha.Frontmatter.Post do
  @moduledoc """
  YAML frontmatter for articles hosted on the site. These are all drawn from
  reddit.com/r/teslore, and have reddit-specific metadata attached to them that
  ordinary site pages do not.
  """

  @behaviour Access

  defstruct [:series, :part, :title, :subtitle, :reddit, :author, :date, :about, {:rest, %{}}]

  @type t :: %__MODULE__{
          series: String.t() | nil,
          part: pos_integer() | nil,
          title: String.t(),
          subtitle: String.t() | nil,
          reddit: String.t(),
          author: String.t(),
          date: DateTime.t(),
          about: String.t() | nil,
          rest: %{}
        }

  @doc """
  Processes an arbitrary map into a Frontmatter structure.
  """
  def new(map) do
    {series, map} = Map.pop(map, "series")
    {part, map} = Map.pop(map, "part")
    {title, map} = Map.pop!(map, "title")
    {subtitle, map} = Map.pop(map, "subtitle")

    {reddit, map} = Map.pop!(map, "reddit")
    {author, map} = Map.pop!(map, "author")
    {date, map} = Map.pop!(map, "date")
    {about, map} = Map.pop(map, "about")

    %__MODULE__{
      series: series,
      part: part,
      title: title,
      subtitle: subtitle,
      reddit: reddit |> to_string(),
      author: author,
      date: date |> Timex.parse!("{RFC3339z}"),
      about: about,
      rest: map
    }
  end

  @impl Access
  def fetch(this, key) do
    this = Map.from_struct(this)
    key = to_string(key)
    {:ok, this[key] || this.rest[key]}
  end
end

defmodule Apocrypha.Frontmatter do
  @type t :: page() | post()

  @type page :: __MODULE__.Page.t()
  @type post :: __MODULE__.Post.t()

  def new_page(meta), do: __MODULE__.Page.new(meta)
  def new_post(meta), do: __MODULE__.Post.new(meta)

  @doc """
  Wraps `YamlFrontMatter` and converts its output into the monadic form.
  """
  def parse(text) when is_binary(text) do
    case YamlFrontMatter.parse(text) do
      {:ok, %{} = meta, rest} -> {:ok, {meta, rest}}
      {:error, error} -> {:error, error}
    end
  end
end
