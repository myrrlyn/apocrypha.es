defmodule Mix.Tasks.Wiki.Index do
  require OK
  use Mix.Task

  @requirements ["app.config"]

  @impl Mix.Task
  def run(args) do
    :ok = File.mkdir_p("priv/data")

    result =
      OK.for do
        reddit <- File.open("priv/data/reddit.txt", [:write, :utf8])
        other <- File.open("priv/data/other.txt", [:write, :utf8])
        worker_am = Task.async(fn -> Apocrypha.Wiki.load_index("index-a-m.md") end)
        worker_nz = Task.async(fn -> Apocrypha.Wiki.load_index("index-n-z.md") end)
        indices_am <- Task.await(worker_am, :infinity)
        indices_nz <- Task.await(worker_nz, :infinity)
      after
        urls = Stream.concat(indices_am, indices_nz) |> Enum.sort(&Apocrypha.url_lessthan/2)

        urls
        |> Stream.each(fn
          {:reddit, ident} -> IO.write(reddit, ident <> "\n")
          {:href, url} -> IO.write(other, url <> "\n")
        end)
        |> Stream.run()

        nil
      end

    case result do
      {:ok, _} -> Mix.shell().info("populated priv/data/*.txt")
      {:error, _} -> Mix.shell().error("could not open indexfile")
    end
  end
end
