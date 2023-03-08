defmodule ApocryphaWeb.PageController do
  use ApocryphaWeb, :controller

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
      meta:
        %Apocrypha.Frontmatter.Post{
          title: title
        } = meta,
      text: text
    } = Apocrypha.Page.load_post!(id <> ".md")

    render(conn, :post,
      classes: ["post", id],
      tab_title: title,
      title: title,
      content: text,
      metadata: meta,
      show_about: true
    )
  end
end
