# Apocrypha

This site hosts a mirror of the [/r/teslore](//reddit.com/r/teslore) collection
of notable fan writings.

It collects text from reddit by scraping the /r/teslore/w/archive page listing.
Collected texts are stored in `priv/pending`.

The community is encouraged to edit texts in `pending` to make them suitable for
placement in `priv/library`. The edits required for this process include, but
are not limited to:

- cutting lines to 80char so that the raw file is nicely readable
- replacing unsemantic markup with semantic (switching bolds to headings where
  appropriate, adding blockquotes, using IAL tag replacement, attaching CSS,
  replacing magic links with styled spans)
- adding or correcting metadata (filling in deleted authors, adding
  subject-matter tags)
- replacing links to other /r/teslore posts that are mirrored here to their
  entry here
- normalizing links to use bibliography style rather than inline
- embedding referenced multimedia
- fixing grammar/spelling

## Development

You will need to install Erlang and Elixir. You can then run the site with
`mix phx.server`.
