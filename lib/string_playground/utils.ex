defmodule StringPlayground.Utils do

  @doc "generates string of the fiven kind with exactly this many graphemes"

  def generate_string(kind, 0) when kind in ~w(ascii alphanumeric printable)a, do: ""
  def generate_string(kind, length) when kind in ~w(ascii alphanumeric printable)a do
    string =
      StreamData.resize(StreamData.string(kind), length)
      |> Stream.filter(& byte_size(&1) > div(length, 4))
      |> Enum.at(1)

    initial_length = String.length(string)

    repeats = div(length, initial_length)
    addon = rem(length, initial_length)

    String.duplicate(string, repeats) <> String.slice(string, 0, addon)
  end
end
