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
          text: String.t()
        }

  @type page :: %__MODULE__{
          meta: Frontmatter.page(),
          text: String.t()
        }

  @type post :: %__MODULE__{
          meta: Frontmatter.post(),
          text: String.t()
        }

  @doc """
  Loads a site page from the filesystem.
  """
  @spec load_page(Path.t()) :: {:ok, page()} | {:error, any()}
  def load_page(path) do
    path = Path.join(["priv", "pages", path])

    with {:ok, meta, text} <- raw_parts(path) do
      {:ok,
       %__MODULE__{
         meta: Frontmatter.new_page(meta),
         text: text |> String.trim()
       }}
    else
      {:error, error} -> {:error, error}
    end
  end

  def render(%__MODULE__{text: text}), do: text |> Apocrypha.Markdown.render()

  @doc """
  Loads a site page from the filesystem, raising on error.
  """
  @spec load_page!(Path.t()) :: page()
  def load_page!(path) do
    path = Path.join(["priv", "pages", path])
    {meta, text} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_page(meta),
      text: text |> String.trim()
    }
  end

  @doc """
  Loads an archived reddit post from the filesystem.
  """
  @spec load_post(Path.t()) :: {:ok, post()} | {:error, any()}
  def load_post(path) do
    path = Path.join(["priv", "archive", path])

    with {:ok, meta, text} <- raw_parts(path) do
      {:ok,
       %__MODULE__{
         meta: Frontmatter.new_post(meta),
         text: text |> String.trim()
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
    {meta, text} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_post(meta),
      text: text |> String.trim()
    }
  end

  def load_draft!(path) do
    path = Path.join(["priv", "pending", path])
    {meta, text} = raw_parts!(path)

    %__MODULE__{
      meta: Frontmatter.new_post(meta),
      text: text |> String.trim()
    }
  end

  def get_banner(%__MODULE__{meta: meta}) do
    meta[:banner] |> Apocrypha.Banners.get_banner()
  end

  defp raw_parts(path), do: YamlFrontMatter.parse_file(path)

  defp raw_parts!(path), do: YamlFrontMatter.parse_file!(path)
end
