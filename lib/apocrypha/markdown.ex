defmodule Apocrypha.Markdown do
  require Logger

  @type toc_tree :: [toc_item]
  @type toc_item :: {String.t(), String.t(), toc_tree}

  @opts %Earmark.Options{
    breaks: false,
    compact_output: true,
    code_class_prefix: "lang- language-",
    footnotes: true,
    gfm: true,
    gfm_tables: true,
    sub_sup: true,
    smartypants: false
  }

  @spec render(String.t()) :: String.t()
  def render(text) do
    text
    |> Earmark.as_ast!(@opts)
    |> Earmark.Transform.map_ast(&__MODULE__.walker/1)
    |> Earmark.Transform.transform(@opts)
  end

  def walker(node)

  # No `<h1>`s in body text. The document title is emitted by the template.
  def walker({"h1", attrs, inner, meta}) do
    Logger.warn("found `# #{inspect(inner)}`; rewriting it to use `## ` instead")
    walker({"h2", attrs, inner, meta})
  end

  # Rewrite tags if requested.
  def walker({_, attrs, inner, meta} = node) do
    case List.keytake(attrs, "tag", 0) do
      {{"tag", new_tag}, rest} -> walker({new_tag, rest, inner, meta})
      _ -> node
    end
  end

  def walker(node), do: node
end
