defmodule Apocrypha.Wiki do
  @moduledoc """
  Interacts with index pages taken from the /r/teslore wiki.

  The reference files live in `priv/wiki/`.
  """

  require Logger
  require OK

  def load_index(filename) do
    path = Path.join(["priv", "wiki", filename])

    OK.for do
      text <- File.read(path)
      Logger.info("loaded indexfile")
      {yaml, text} <- Apocrypha.Frontmatter.parse(text)
      {ast, deprs} <- Apocrypha.Markdown.as_ast(text)
    after
      Logger.info("parsed indexfile")

      ast
      |> Apocrypha.Markdown.local_transform()
      |> query_table_tbody_tr_tdfirst_a_href()
      |> Stream.flat_map(fn
        {"href", href} ->
          case Apocrypha.discover_ident(href) do
            {:ok, ident} -> [{:reddit, ident}]
            _ -> [{:href, href}]
          end

        _ ->
          []
      end)

      # |> Stream.map(&IO.inspect/1)
      # |> Enum.to_list()
    end
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
      |> Stream.filter(fn {tag, _, _, _} -> Enum.member?(["h3", "table"], tag) end)
      # and in a table, we only actually care about its post links
      |> query_table_tbody_tr_tdfirst_a_href()
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
      |> Stream.map(fn {k, vs} -> {k, Enum.sort(vs, &Apocrypha.url_lessthan/2)} end)
    end
  end

  # We know that the index tables are all laid out as
  # `<tr><td><a href="the post">...</a></td>...</tr>`, so this function extracts
  # just the hrefs from an index table, and passes through other AST nodes
  # unchanged
  def query_table_tbody_tr_tdfirst_a_href(ast) do
    ast
    |> Stream.flat_map(fn
      {"table", _, table_parts, _} ->
        table_parts
        |> Stream.filter(fn
          {"tbody", _, _, _} -> true
          _ -> false
        end)
        |> Stream.flat_map(fn
          {"tbody", _, trs, _} -> trs
          _ -> []
        end)
        |> Stream.flat_map(fn
          {"tr", _, [td | _], _} -> [td]
          _ -> []
        end)
        |> Stream.flat_map(fn
          {"td", _, cell, _} -> cell
          _ -> []
        end)
        |> Stream.flat_map(fn
          {"a", attrs, _, _} -> attrs
          _ -> []
        end)
        |> Stream.filter(fn
          {"href", _} -> true
          _ -> false
        end)

      other ->
        [other]
    end)
  end
end
