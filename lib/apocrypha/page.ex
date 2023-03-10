defmodule Apocrypha.Page do
  @moduledoc """
  Manages site-pages and reddit-posts that are stored on the filesystem.

  Both site-pages and archived posts are stored as Markdown files with a YAML
  frontmatter block.
  """

  alias Apocrypha.{Markdown, Frontmatter}

  defstruct [:meta, :text, :src]

  @type t :: %__MODULE__{
          meta: Frontmatter.t(),
          text: String.t(),
          src: String.t()
        }

  @type page :: %__MODULE__{
          meta: Frontmatter.page(),
          text: String.t(),
          src: String.t()
        }

  @type post :: %__MODULE__{
          meta: Frontmatter.post(),
          text: String.t(),
          src: String.t()
        }

  @doc """
  Loads a site page from the filesystem.
  """
  @spec load_page(Path.t()) :: {:ok, page()} | {:error, any()}
  def load_page(path) do
    path = Path.join(["priv", "pages", path])

    with {:ok, meta, text, src} <- raw_parts(path) do
      {:ok,
       %__MODULE__{
         meta: Frontmatter.new_page(meta),
         text: text |> String.trim() |> Markdown.render(),
         src: src
       }}
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
    {meta, text, src} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_page(meta),
      text: text |> String.trim() |> Markdown.render(),
      src: src
    }
  end

  @doc """
  Loads an archived reddit post from the filesystem.
  """
  @spec load_post(Path.t()) :: {:ok, post()} | {:error, any()}
  def load_post(path) do
    path = Path.join(["priv", "archive", path])

    with {:ok, meta, text, src} <-raw_parts(path) do
      {:ok,
       %__MODULE__{
         meta: Frontmatter.new_post(meta),
         text: text |> String.trim() |> Markdown.render(),
         src: src
       }}
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
    {meta, text, src} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_post(meta),
      text: text |> String.trim() |> Markdown.render(),
      src: src
    }
  end

  def load_draft!(path) do
    path = Path.join(["priv", "pending", path])
    {meta, text, src} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_post(meta),
      text: text |> String.trim() |> Markdown.render(),
      src: src
    }
  end

  def get_banner(%__MODULE__{meta: meta}) do
    meta[:banner] |> Apocrypha.Banners.get_banner()
  end

  defp raw_parts(path) do
    with {:file, {:ok, src}} <- {:file, File.read(path)},
    {:yaml, {:ok, meta, text}} <- {:yaml, YamlFrontMatter.parse(src)} do
      {:ok, meta, text, src}
    else
      {:file, {:error, error}} -> {:error, error}
      {:yaml, {:error, error}} -> {:error, error}
    end
  end

  defp raw_parts!(path) do
    src = File.read!(path)
    {meta, text} = YamlFrontMatter.parse!(src)
    {meta, text, src}
  end
end
