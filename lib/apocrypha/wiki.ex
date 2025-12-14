defmodule Apocrypha.Wiki do
  @moduledoc """
  Interacts with index pages taken from the /r/teslore wiki.

  The reference files live in `priv/wiki/`.
  """

  require OK

  def load_index() do
    nil
  end

  def load_tagfile(name) do
    path = Path.join(["priv", "wiki", name])

    OK.for do
      # load the file off disk
      text <- File.read(path)
      # it probably has frontmatter; skip it
      {yaml, text} <- Apocrypha.Frontmatter.parse(text)
      # process the markdown into an AST that we can walk
      {ast, deprs} <- Apocrypha.Markdown.as_ast(text)
    after
      ast
      # never hurts
      |> Apocrypha.Markdown.local_transform()
      # we only care about h3 and tables, since that's where the data lives
      |> Stream.filter(fn {tag, attrs, children, meta} -> Enum.member?(["h3", "table"], tag) end)
      # and in a table, we only actually care about its contents
      |> Stream.flat_map(fn
        {"table", attrs, children, meta} -> children
        other -> [other]
      end)
      # specifically, not the header, only the body
      |> Stream.reject(fn
        {"thead", _, _, _} -> true
        _ -> false
      end)
      # and in the body, only the <tr>s
      |> Stream.flat_map(fn
        {"tbody", _, rows, _} -> rows
        other -> [other]
      end)
      # and in the <tr>, only the first <td><a>'s attributes
      |> Stream.flat_map(fn
        {"tr", _, [{"td", _, [{"a", attrs, _, _} | _], _} | _], _} -> attrs
        other -> [other]
      end)
      # now that the stream is only <h3> and the attrs of `tbody tr td:first-child a`, get the data
      |> Stream.flat_map(fn
        # headings are the tag names
        {"h3", [], [tag], %{}} ->
          [{:tag, tag}]

        # links are the destination
        {"href", href} ->
          case Apocrypha.discover_ident(href) do
            {:ok, ident} -> [{:reddit, ident}]
            _ -> [{:href, href}]
          end

        # anything else is dross
        _ ->
          []
      end)
      |> Enum.reduce({"__unknown", %{}}, fn
        # the stream is temporally ordered. encountering a tagname changes the
        # current bucket name in the accumulator
        {:tag, name}, {current, accum} ->
          {String.downcase(name), accum}

        # encountering a value (:reddit or :href) puts the URL in the current
        # bucket of the accumulator
        {kind, url}, {current, accum} ->
          {current,
           Map.update(accum, current, MapSet.new([{kind, url}]), &MapSet.put(&1, {kind, url}))}
      end)
      |> (&elem(&1, 1)).()
      |> Stream.map(fn {k, vs} -> {k, Enum.sort_by(vs, & &1, &Apocrypha.url_lessthan/2)} end)
    end
  end
end
