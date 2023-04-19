defmodule StringPlayground.Utils do
  @doc "generates string of the fiven kind with exactly this many graphemes"

  def generate_string(kind, 0) when kind in ~w(ascii alphanumeric printable)a, do: ""

  def generate_string(kind, length) when kind in ~w(ascii alphanumeric printable)a do
    string =
      StreamData.resize(StreamData.string(kind), length)
      |> Stream.filter(&(byte_size(&1) > div(length, 4)))
      |> Enum.at(1)

    initial_length = String.length(string)

    repeats = div(length, initial_length)
    addon = rem(length, initial_length)

    String.duplicate(string, repeats) <> String.slice(string, 0, addon)
  end

  def check_palindrome_with_string_at(s) do
    len = String.length(s)

    Range.new(0, div(len, 2) - 1, 1)
    |> Enum.reduce_while(true, fn index, _still_palindrome ->
      if String.at(s, index) == String.at(s, len - index - 1) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  def check_palindrome_with_binary_part(s) do
    len = byte_size(s)

    Range.new(0, div(len, 2) - 1, 1)
    |> Enum.reduce_while(true, fn index, _still_palindrome ->
      if binary_part(s, index, 1) == binary_part(s, len - index - 1, 1) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  def check_palindrome_with_string_reverse(s) do
    s == String.reverse(s)
  end

  def check_palindrome_with_graphemes(s) do
    graphemes = String.graphemes(s)
    reversed_graphemes = Enum.reverse(graphemes)
    compare_beginning(graphemes, reversed_graphemes, div(byte_size(s), 2))
  end

  defp compare_beginning(l1, l2, count)

  defp compare_beginning([], [], _), do: true
  defp compare_beginning([], [_ | _], _), do: false
  defp compare_beginning([_ | _], [], _), do: false
  defp compare_beginning(_, _, 0), do: true

  defp compare_beginning([h | t1], [h | t2], i) do
    compare_beginning(t1, t2, i - 1)
  end

  defp compare_beginning([_h1 | _], [_h2 | _], _), do: false
end
