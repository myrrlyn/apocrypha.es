defmodule ApocryphaWeb.PageController do
  use ApocryphaWeb, :controller

  @repo_base "https://github.com/myrrlyn/apocrypha.es/blob/main/priv"

  def home(conn, _params) do
    page = Apocrypha.Page.load_page!("home.md")

    render(conn, :page,
      classes: ["home"],
      content: Apocrypha.Page.render(page),
      metadata: page.meta,
      show_about: false
    )
  end

  def style(conn, _params) do
    %Apocrypha.Page{meta: meta} = page = Apocrypha.Page.load_page!("style-guide.md")

    text =
      Apocrypha.Page.render(page) <>
        "<hr /><section><pre><code>" <>
        (File.read!("priv/pages/style-guide.md")
         |> String.trim()
         |> Phoenix.HTML.html_escape()
         |> Phoenix.HTML.safe_to_string()) <>
        "</code></pre></section>"

    render(conn, :page, classes: ["style-guide"], content: text, metadata: meta, show_about: false)
  end

  def random(conn, _params) do
    posts = Apocrypha.Library.get_index()
    idx = posts |> length() |> :rand.uniform() |> (&(&1 - 1)).()
    meta = posts |> Enum.at(idx)

    redirect(conn, to: ~p"/a/#{meta.reddit}")
  end

  def articles(conn, _params) do
    index = Task.async(&Apocrypha.Library.build_index/0)
    page = Apocrypha.Page.load_page!("articles.md")

    out =
      render(conn, :articles,
        classes: ["index"],
        show_about: false,
        content: Apocrypha.Page.render(page),
        metadata: page.meta,
        show_about: false
      )

    Task.await(index)
    out
  end

  def draft_articles(conn, _params) do
    page = Apocrypha.Page.load_page!("draft-articles.md")

    render(conn, :draft_articles,
      classes: ["draft-index"],
      show_about: false,
      content: Apocrypha.Page.render(page),
      metadata: page.meta,
      show_about: false
    )
  end

  def all_series(conn, _params) do
    index = Task.async(&Apocrypha.Library.build_index/0)
    page = Apocrypha.Page.load_page!("series-index.md")
    all_series = Apocrypha.Library.group_by_series()

    out =
      render(conn, :grouped,
        classes: ["series-index"],
        class: ["text-title"],
        show_about: false,
        content: Apocrypha.Page.render(page),
        metadata: page.meta,
        all_groups: all_series
      )

    Task.await(index)
    out
  end

  def all_authors(conn, _params) do
    index = Task.async(&Apocrypha.Library.build_index/0)
    page = Apocrypha.Page.load_page!("authors-index.md")
    all_authors = Apocrypha.Library.group_by_authors()

    out =
      render(conn, :grouped,
        classes: ["authors-index"],
        class: [],
        show_about: false,
        content: Apocrypha.Page.render(page),
        metadata: page.meta,
        all_groups: all_authors
      )

    Task.await(index)
    out
  end

  def article(conn, %{"id" => id} = _params) do
    post = Apocrypha.Page.load_post!(id <> ".md")

    render(conn, :post,
      classes: ["post", id],
      content: Apocrypha.Page.render(post),
      metadata: post.meta,
      show_about: true,
      github_link: "#{@repo_base}/archive/#{id}.md"
    )
  end

  def draft_article(conn, %{"id" => id} = _params) do
    post = Apocrypha.Page.load_draft!(id <> ".md")

    render(conn, :post,
      classes: ["draft-post", id],
      content: Apocrypha.Page.render(post),
      metadata: post.meta,
      show_about: true,
      github_link: "#{@repo_base}/pending/#{id}.md"
    )
  end

  def asset(conn, %{"id" => id, "asset" => asset}) do
    Plug.Conn.send_file(conn, 200, Path.join(["priv", "archive", id, asset]))
  end

  def draft_asset(conn, %{"id" => id, "asset" => asset}) do
    Plug.Conn.send_file(conn, 200, Path.join(["priv", "pending", id, asset]))
  end
end
