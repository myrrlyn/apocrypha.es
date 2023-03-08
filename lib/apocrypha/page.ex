defmodule Apocrypha.Page do
  @moduledoc """
  Manages site-pages and reddit-posts that are stored on the filesystem.

  Both site-pages and archived posts are stored as Markdown files with a YAML
  frontmatter block.
  """

  alias Apocrypha.{Markdown, Frontmatter}

  defstruct [:meta, :text]

  @type t :: %__MODULE__{
    meta: Frontmatter.t(),
    text: String.t(),
  }

  @type page :: %__MODULE__{
    meta: Frontmatter.page(),
    text: String.t(),
  }

  @type post :: %__MODULE__{
    meta: Frontmatter.post(),
    text: String.t(),
  }

  @doc """
  Loads a site page from the filesystem.
  """
  @spec load_page(Path.t()) :: {:ok, page()} | {:error, any()}
  def load_page(path) do
    path = Path.join(["priv", "pages", path])
    with {:ok, meta, text} <- YamlFrontMatter.parse_file(path) do
      {:ok, %__MODULE__{meta: Frontmatter.new_page(meta), text: text |> String.trim() |> Markdown.render()}}
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Loads a site page from the filesystem, raising on error.
  """
  @spec load_page!(Path.t()) :: page()
  def load_page!(path) do
    path = Path.join(["priv", "pages", path])
    {meta, text} = YamlFrontMatter.parse_file!(path)
    %__MODULE__{meta: Frontmatter.new_page(meta), text: text |> String.trim() |> Markdown.render()}
  end

  @doc """
  Loads an archived reddit post from the filesystem.
  """
  @spec load_post(Path.t()) :: {:ok, post()} | {:error, any()}
  def load_post(path) do
    path = Path.join(["priv", "archive", path])
    with {:ok, meta, text} <- YamlFrontMatter.parse_file(path) do
      {:ok, %__MODULE__{meta: Frontmatter.new_post(meta), text: text |> String.trim() |> Markdown.render()}}
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Loads an archived reddit post from the filesystem, raising on error.
  """
  @spec load_post!(Path.t()) :: post()
  def load_post!(path) do
    path = Path.join(["priv", "archive", path])
    {meta, text} = YamlFrontMatter.parse_file!(path)
    %__MODULE__{meta: Frontmatter.new_post(meta), text: text |> String.trim() |> Markdown.render()}
  end
end
