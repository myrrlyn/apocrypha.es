defmodule Mix.Tasks.Wiki.Index do
  require OK
  use Mix.Task

  @requirements ["app.config"]

  @impl Mix.Task
  def run(args) do
    result =
      OK.for do
        indices_am <- Apocrypha.Wiki.load_index("index-a-m.md")
        indices_nz <- Apocrypha.Wiki.load_index("index-n-z.md")
      after
        Stream.concat(indices_am, indices_nz) |> Enum.to_list()
      end

    case result do
      {:ok, posts} -> Mix.shell().info(inspect(posts))
      {:error, _} -> Mix.shell().error("could not open indexfile")
    end
  end
end
