defmodule Mix.Tasks.Wiki do
  @moduledoc """
  Processes /r/teslore wiki files stored in `priv/wiki/`.
  """
end

defmodule Mix.Tasks.Wiki.Tags do
  @moduledoc """
  Evaluates `priv/wiki/topics-*.md` files and emits an `{ident, tag}` stream.
  """

  require OK
  use Mix.Task

  @requirements ["app.config", "app.start"]

  @impl Mix.Task
  def run(args) do
    tags =
      OK.for do
        tags_am <- Apocrypha.Wiki.load_tagfile("topics-a-m.md")
        tags_nz <- Apocrypha.Wiki.load_tagfile("topics-n-z.md")
      after
        Stream.concat(tags_am, tags_nz)
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.to_list()
      end

    case tags do
      {:ok, tags} -> Mix.shell().info(inspect(tags))
      {:error, _} -> Mix.shell().error("could not open tagfile(s)")
    end
  end
end
