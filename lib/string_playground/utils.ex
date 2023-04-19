defmodule StringPlayground.Utils do
  @doc "generates string of the fiven kind with exactly this many graphemes"

  def generate_string(kind, 0) when kind in ~w(ascii alphanumeric printable)a, do: ""

  def generate_string(kind, length) when kind in ~w(ascii alphanumeric printable)a do
      StreamData.string(kind, length: length)
      |> Enum.at(1)
  end

  # NOTE: none of the palindrome functions take unicode normalization into account
  # SEE https://hexdocs.pm/elixir/String.html#normalize/2

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
