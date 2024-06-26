defmodule Apocrypha do
  @moduledoc """
  Apocrypha keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Translates a month number (1-12) into its English name.
  """
  @spec month_name(1..12) :: nonempty_binary()
  def month_name(num) when num in 1..12 do
    case num do
      1 -> "January"
      2 -> "February"
      3 -> "March"
      4 -> "April"
      5 -> "May"
      6 -> "June"
      7 -> "July"
      8 -> "August"
      9 -> "September"
      10 -> "October"
      11 -> "November"
      12 -> "December"
    end
  end

  def month_abbr(num) when num in 1..12 do
    case num do
      1 -> "Jan"
      2 -> "Feb"
      3 -> "Mar"
      4 -> "Apr"
      5 -> "May"
      6 -> "Jun"
      7 -> "Jul"
      8 -> "Aug"
      9 -> "Sep"
      10 -> "Oct"
      11 -> "Nov"
      12 -> "Dec"
    end
  end

  @doc """
  Generates a table-of-contents anchor string for a date fragment.
  """
  @spec toc_anchor(pos_integer()) :: nonempty_binary()
  def toc_anchor(year), do: "y#{year}"

  @spec toc_anchor(pos_integer(), 1..12) :: nonempty_binary()
  def toc_anchor(year, month) do
    month = month |> to_string() |> String.pad_leading(2, "0")
    toc_anchor(year) <> "m#{month}"
  end

  def to_ident(text) do
    text
    |> String.downcase()
    |> String.replace(~r/["']/, "")
    |> String.replace(~r/[^a-z0-9]/, "-")
    |> String.replace(~r/--+/, "-")
  end

  def to_title(text) do
    text
    |> String.replace(~r/[-_]/, " ")
    |> String.split()
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def pluralize(number, singular), do: pluralize(number, singular, singular <> "s")

  def pluralize(number, singular, plural) do
    if number == 1, do: "#{number} #{singular}", else: "#{number} #{plural}"
  end
end
