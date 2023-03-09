defmodule Apocrypha.Banners.Banner do
  defstruct file: nil, caption: nil, pos: {"center", "center"}, dim: nil

  def new(%{file: file, caption: caption} = attrs) do
    {pos, attrs} = attrs |> Map.pop(:pos, {:center, :center})
    {dim, _attrs} = attrs |> Map.pop(:dim, [{:height, 128}])

    %__MODULE__{
      caption: caption,
      file: Path.join(["/images", "banners", file]),
      pos: pos,
      dim: dim
    }
  end

  def style_rules(%__MODULE__{file: file, pos: {x, y}, dim: [{:width, width}, {:height, height}]}) do
    """
    aspect-ratio: #{width} / #{height};
    background-image: url(#{file});
    background-position: #{x} #{y};
    """
  end

  def style_rules(%__MODULE__{file: file, pos: {x, y}, dim: [{:height, height}]}) do
    """
    background-image: url(#{file});
    background-position: #{x} #{y};
    height: #{height}px;
    """
  end

  def style_rules(%__MODULE__{}) do
    ""
  end
end

defmodule Apocrypha.Banners.TomlTransform do
  @moduledoc """
  Helper functions to turn bare TOML values into more structured data.
  """

  use Toml.Transform

  def transform(:pos, %{x: x, y: y} = pos) when is_map(pos) do
    x =
      case x do
        "left" -> :left
        "center" -> :center
        "right" -> :right
        other -> other
      end

    y =
      case y do
        "top" -> :top
        "center" -> :center
        "bottom" -> :bottom
        other -> other
      end

    {x, y}
  end

  def transform(:pos, pos) do
    {:error, {:invalid_position, pos, :expected_x_y_pair}}
  end

  def transform(:dim, %{width: width, height: height} = pos) when is_map(pos) do
    [{:width, width}, {:height, height}]
  end

  def transform(:dim, %{height: h} = pos) when is_map(pos) do
    [{:height, h}]
  end

  def transform(:dim, dim) do
    {:error, {:invalid_dimensions, dim, :expected_height_or_width_height_pair}}
  end

  def transform(:banners, all_banners) when is_map(all_banners) do
    prepend_album = fn album, %{file: file} = object ->
      Apocrypha.Banners.Banner.new(%{object | file: Path.join(album |> to_string(), file)})
    end

    for {album, banners} <- all_banners do
      case banners do
        named when is_map(named) ->
          {album,
           named
           |> Enum.map(fn {name, object} ->
             {name, prepend_album.(album, object)}
           end)
           |> Enum.into(%{})}

        unnamed when is_list(unnamed) ->
          {album,
           unnamed
           |> Enum.map(fn object ->
             prepend_album.(album, object)
           end)
           |> Enum.into([])}

        _ ->
          raise "unexpected collection"
      end
    end
    |> Enum.into(%{})
  end

  def transform(_key, value), do: value
end

defmodule Apocrypha.Banners do
  @banners ["assets", "banners.toml"]
           |> Path.join()
           |> File.stream!()
           |> Toml.decode_stream!(keys: :atoms, transforms: [__MODULE__.TomlTransform])
           |> Enum.map(fn {name, map} -> {name |> to_string(), __MODULE__.Banner.new(map)} end)
           |> Enum.into(%{})

  def all_banners(), do: @banners

  def get_banner(name) do
    case @banners[name |> to_string()] do
      nil ->
        banners = @banners |> Map.values()
        idx = banners |> length() |> :rand.uniform()
        banners |> Enum.at(idx - 1)
      banner -> banner
    end
  end
end
