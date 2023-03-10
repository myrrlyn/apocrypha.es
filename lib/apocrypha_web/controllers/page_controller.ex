defmodule ApocryphaWeb.PageController do
  use ApocryphaWeb, :controller

  @repo_base "https://github.com/myrrlyn/apocrypha.es/blob/main/priv"

  def home(conn, _params) do
    page = Apocrypha.Page.load_page!("home.md")

    render(conn, :page,
      classes: ["home"],
      content: page.text,
      metadata: page.meta,
      show_about: false
    )
  end

  def style(conn, _params) do
    %Apocrypha.Page{meta: meta, text: text, src: src} =
      Apocrypha.Page.load_page!("style-guide.md")

    text =
      text <>
        "<hr /><section><pre><code>" <>
        (src |> String.trim() |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()) <>
        "</code></pre></section>"

    render(conn, :page, classes: ["style-guide"], content: text, metadata: meta, show_about: false)
  end

  def random(conn, _params) do
    posts = Path.join(["priv", "archive", "*.md"]) |> Path.wildcard()
    idx = posts |> length() |> :rand.uniform() |> (&(&1 - 1)).()
    name = posts |> Enum.at(idx)
    post = name |> Path.basename() |> Apocrypha.Page.load_post!()

    render(conn, :page,
      classes: ["post"],
      content: post.text,
      metadata: post.meta,
      github_link: @repo_base <> String.trim_leading(name, "priv"),
      show_about: true
    )
  end

  def articles(conn, _params) do
    page = Apocrypha.Page.load_page!("articles.md")

    render(conn, :articles,
      classes: ["index"],
      show_about: false,
      content: page.text,
      metadata: page.meta,
      show_about: false
    )
  end

  def article(conn, %{"id" => id} = _params) do
    post = Apocrypha.Page.load_post!(id <> ".md")

    render(conn, :post,
      classes: ["post", id],
      content: post.text,
      metadata: post.meta,
      show_about: true,
      github_link: "#{@repo_base}/archive/#{id}.md"
    )
  end

  def draft_article(conn, %{"id" => id} = _params) do
    post = Apocrypha.Page.load_draft!(id <> ".md")

    render(conn, :post,
      classes: ["draft-post", id],
      content: post.text,
      metadata: post.meta,
      show_about: true,
      github_link: "#{@repo_base}/pending/#{id}.md"
    )
  end
end
