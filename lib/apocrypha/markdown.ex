defmodule Apocrypha.Markdown do
  require Logger
  require OK

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

  def as_ast(text) when is_binary(text) do
    case Earmark.Parser.as_ast(text, @opts) do
      {:ok, ast, deprecations} -> {:ok, {ast, deprecations}}
      {:error, ast, errors} -> {:error, {ast, errors}}
    end
  end

  @spec local_transform({Earmark.ast_node(), map()} | Earmark.Parser.ast()) :: Earmark.ast_node()
  def local_transform({ast, deprecations}) when is_list(deprecations) do
    local_transform(ast)
  end

  def local_transform(ast) do
    ast
    |> Earmark.Transform.map_ast(&__MODULE__.walker/1)
  end

  @spec render(String.t()) :: String.t()
  def render(text) when is_binary(text) do
    text
    |> Earmark.as_ast!(@opts)
    |> Earmark.Transform.map_ast(&__MODULE__.walker/1)
    |> render()
  end

  def render(ast) when is_list(ast) do
    ast |> Earmark.Transform.transform(@opts) |> String.replace("&amp;nbsp;", "&nbsp;")
  end

  def walker(node)

  # No `<h1>`s in body text. The document title is emitted by the template.
  def walker({"h1", attrs, inner, meta}) do
    Logger.warning("found `# #{inspect(inner)}`; rewriting it to use `## ` instead")
    walker({"h2", attrs, inner, meta})
  end

  # Rewrite tags if requested.
  def walker({tag, attrs, inner, meta} = node) do
    case List.keytake(attrs, "tag", 0) do
      {{"tag", new_tag}, rest} -> walker({new_tag, rest, inner, meta})
      _ -> node
    end
  end

  def walker(node), do: node
end
