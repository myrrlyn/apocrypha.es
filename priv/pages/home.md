---
title: Apocrypha
tab_suffix: ""
---

Welcome to the [/r/teslore] apocryphal collection!

## What It Is

This site is a project by [/u/myrrlyn] that aims to migrate the /r/teslore
[Text Archive][0] to an off-reddit mirror that (a) won’t be affected by user
deletions and (b) will have nicer presentation (and maybe discovery?). The goal
is to eventually look like myrrlyn’s [oeuvre][1], with rich CSS, inline media,
and specialty fonts.

## How It Works

We have [a scraper][2] that downloads all extant texts from the subreddit
archive and stores them as Markdown with YAML frontmatter. These raw files are
able to be served directly, but are likely in need of polish and review.

The polish process uses these steps as needed:

- replace ASCII punctuation (single and double quotes, double and triple
  hyphens, etc) with their Unicode replacements (left and right single and
  double quotes, en and em dashes, etc)
- normalize Markdown formatting (any-underscore `<hr>` to four-hyphen `<hr>`,
  prune the heading tree)
- normalize inline links to use the bibliography syntax (`[text][idx]` inline,
  `[idx]: link "title"` at end of document)
- use Markdown footnotes where authors rolled their own
- cut lines to 80 characters so that the raw file is more easily readable
- use IAL tag replacement (`{:tag="new-html-tag"}`) to create semantic HTML for
  things like cited blockquotes or styled spans
- remove in-document `<h1>` titles, as the article template generates them
- render media inline
- fix spelling and grammar
- move out-of-character author notes into the `about:` metadata

Additionally, metadata must be managed for each article as it is processed:

- entries in a series need `series:` and `part:` keys
- the `title:` might be split into a `subtitle:` key as well
- remove quotes from values that don’t need them. The quotes are automatically
  inserted by the scraper due to pessimal input, but *most* documents don’t
  require this level of caution.

We hope to eventually have a tagging system so that articles can be grouped by
topics they cover. Since there are roughly three thousand posts in the archive,
this is currently punted to future work while we (a) determine which tags would
even be relevant and (b) sketch out a way to keep tagged documents consistent.

For an example of the disaster that results from even a small data set with
unmanaged tags, see myrrlyn’s oeuvre listing. There are seven tags with one
member each, and the `#apocrypha` tag includes over half (13/22) of the hosted
articles.

## How You Can Help

1. Clone <https://github.com/myrrlyn/apocrypha.es>.

   If you’re comfortable installing the Elixir and Erlang programming language
   runtimes, please do so, then use `mix phx.server` to run the application. You
   can view it at <http://localhost:5673> and see your work happen live!
1. Pick some articles in `pending/` that you like (perhaps your own! search for
   `author: "your username"` (with quotes)).
1. Move them from `pending/` to `archive/` so that the server will render them.
1. Make them look like the other articles in `archive/`, following the steps
   outlined above.
1. Submit a pull request!

If you have questions about the process, ideas about things we’ve missed, or
basically any feedback, *please* feel free to ping /u/myrrlyn on reddit. This is
a community project and can only be successful with community input.

## Can You Add Your Own Posts

Sure, why not. Submit a PR with a new document containing the raw Markdown
source of your article (which you can get by editing it, copying out all the
text, and cancelling the edit) and the relevant metadata.

[0]: //reddit.com/r/teslore/w/archive
[1]: //myrrlyn.net/oeuvre
[2]: //myrrlyn.net/hermaeus
[/r/teslore]: //reddit.com/r/teslore
[/u/myrrlyn]: //reddit.com/u/myrrlyn
