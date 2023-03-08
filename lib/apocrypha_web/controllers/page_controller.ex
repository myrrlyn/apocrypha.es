defmodule ApocryphaWeb.PageController do
  use ApocryphaWeb, :controller

  @repo_base "https://github.com/myrrlyn/apocrypha.es/blob/main/priv"

  def home(conn, _params) do
    %Apocrypha.Page{
      meta: meta,
      text: text
    } = Apocrypha.Page.load_page!("home.md")

    render(conn, :page,
      classes: ["home"],
      content: text,
      metadata: meta,
      show_about: false
    )
  end

  def articles(conn, _params) do
    %Apocrypha.Page{meta: meta, text: text} = Apocrypha.Page.load_page!("articles.md")

    render(conn, :articles,
      classes: ["index"],
      show_about: false,
      content: text,
      metadata: meta,
      show_about: false
    )
  end

  def article(conn, %{"id" => id} = _params) do
    %Apocrypha.Page{
      meta: meta,
      text: text
    } = Apocrypha.Page.load_post!(id <> ".md")

    render(conn, :post,
      classes: ["post", id],
      content: text,
      metadata: meta,
      show_about: true,
      github_link: "#{@repo_base}/archive/#{id}.md"
    )
  end

  def draft_article(conn, %{"id" => id} = _params) do
    %Apocrypha.Page{meta: meta, text: text} = Apocrypha.Page.load_draft!(id <> ".md")

    render(conn, :post,
      classes: ["draft-post", id],
      content: text,
      metadata: meta,
      show_about: true,
      github_link: "#{@repo_base}/pending/#{id}.md"
    )
  end
end
