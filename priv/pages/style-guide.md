---
# This is YAML frontmatter, *not* a setex heading
title: Style Guide
banner: text-kel
---

While this site is primarily Markdown-based, and strives to be capable of
rendering Markdown text faithfully to the CSS on /r/teslore[^1], it extends the
Markdown processor to allow a much richer set of controls than reddit, or even
standard Markdown, can express.

We edit the source texts scraped from reddit in order to give them a better
semantic structure, embed linked media directly in the document, and take full
advantage of our technical capabilities.

## How Our Markdown Works

The Markdown text used to create this page is presented at the bottom, so you
can compare the source text to the rendered browser page.

In addition to the CommonMark standard, we support:

- footnotes: these use the reference-link syntax, but begin the link ID with a
  caret: place `[^num]` in your document to create a superscripted footnote
  link, and `[^num]: text` at the _end_ of the document to fill in its text.

  The footnote definitions must be placed at the **very end** of the document,
  after _all_ other ordinary Markdown elements, even inivisible ones like a
  bibliography link collection.
  The text can span multiple lines, and is not indented like list items are.[^2]

- superscripts: like reddit, we have superscripts; unlike reddit, we require a
  leading and trailing caret: e^𝑖π^ = -1.

- subscripts: these are delimited by single tildes (`~`): C~6~H~12~O~6~ is a
  simple sugar.

- We support _Inline Attribute Lists_, first introduced by [Kramdown]. These are
  markers of the form `{: #id .class key="value"}` placed after the element they
  modify.

- TES fonts: Using custom classes (described next), you can render some text in
  fonts taken from the games. `.handwriting` uses the _Skyrim_ journal font;
  `.dovah`, `.dwemer`, `.falmer`, and `.daedric` do exactly what they say, and
  `.ehlnofex` uses the font shown on the Eye of Magnus. You can also use an IAL
  to apply the `lang="x-NAME"` attribute.

- HTML attributes: the inline attribute list described above allows you to write
  HTML attributes and attach them to the HTML tag that your Markdown will
  produce. _This text is colored by an IAL._{:style="color: forestgreen;"}

- HTML tag replacement: the special attribute `{:tag="new_tag"}` causes the
  Markdown engine to change the generated tag to use the provided tag,
  preserving the rest of its attributes and children. This means that you can
  turn `> blockquotes` or `_italics_` into arbitrary block- or inline- HTML
  elements.

  Restrictions: the Markdown engine _does not parse_ inside code elements. You
  can still rewrite their tag, but their contents are shown verbatim.

  Additionally, Markdown blocks that produce two-layer HTML nodes
  (triple-backticks produces `<pre><code>`; `- list` produces `<ul><li>`, and
  `1. list` produces `<ol><li>`) discard their IALs, as the engine cannot
  determine whether the attributes should be attached to the outer or inner
  layer.

- YAML frontmatter: hosted apocrypha require some metadata alongside the actual
  text. This is how we manage collecting posts into a series (`series:` and
  `part:`), provide a `title:` and `subtitle:`, link to the original `reddit:`
  post ID, name the `author:` who wrote it, and show the `date:` at which it was
  posted. You can also specify a `banner:` image from the following:

  - `c0da-1` through `c0da-4`
  - `dragons` or `dragons-sepia`
  - `elder-scroll`
  - `magnus`
  - `map-cyrod`, `map-skyrim`, `map-stylized`, or `map-wilderness`
  - `numinatus`
  - `oblivion`
  - `seas`
  - `text-daedric`, `text-kel`, or `text-oghma`
  - `tools` or `tools-active`
  - `wilds`, `wilds-morrowind`, or `wilds-morrowind-2`

## What Your Markdown Should Be

Now that reddit has deprecated custom CSS, _chances are_ your audience isn’t
looking at your post on <https://old.reddit.com/r/teslore>, so they aren’t
seeing the custom CSS. You should write your Markdown normally. This means:

- use `## actual headings` for sectioning, not bolds or blockquotes to simulate
  headings.
- don’t use `# h1` _at all_. The template injects the document `title:` as the
  only `<h1>` element, and the optional `subtitle:` right below it as an `<h2>`.
  The Markdown engine automatically downgrades `# h1` elements to `## h2`.
- _don’t_ use headings to manage your text size. We have CSS classes for that.
- use `> blockquotes` liberally, and name the source _inside_ the blockquote
  with an IAL:

  > This is a blockquote. It even has a citation attached!
  >
  > _This is the citation. It automatically gets an em-dash prefix!_
  > {:tag="cite"}

- prefer using _italics_ for your inline IAL replacements, rather than `code`,
  since engines that don’t process IALs will still render this as visually
  distinct but not obnoxiously strange
- we don’t acknowledge, and in fact actively remove, trailing whitespace on
  lines of text. this means that trailing spaces can’t be used to create
  `<br />` elements. If you need those, the only way to create an empty inline
  element is, unfortunately, an empty link: `[](){:tag="br"}`.
- wrap your lines at 80 columns

[Kramdown]: https://kramdown.gettalong.org/syntax.html#inline-attribute-lists

[^1]: conveniently, /u/myrrlyn is the author of both /r/teslore’s CSS and this
website, so compatibility is only a question of motivation, not ability.

[^2]: yes, it’s a little confusing, but that’s life.
