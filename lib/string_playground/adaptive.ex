defmodule StringPlayground.Adaptive do
  # see https://ardislu.dev/biggest-unicode-grapheme-cluster
  @lookback_in_bytes 50

  @spec slice_beginning(String.t(), integer) :: {integer, String.t()}
  @doc """
  Slices *at most* bytes from the beginning of the string, without breaking boundaries of any
  graphemes. Both the returned slice and the part not returned will be valid strings if
  the input string itself is valid

  Returns the actual byte size of the returned slice and the slice itself
  """
  def slice_beginning(string, length) when is_binary(string) and is_integer(length) and length >= 0 do
    do_slice_beginning(string, length)
  end

  defp do_slice_beginning(string, length) when length >= byte_size(string), do: {byte_size(string), string}

  defp do_slice_beginning(string, length) do
    lookback_start = max(0, length - 1 - @lookback_in_bytes)
    # looking forward as well in case it's a grapheme cluster, like é, which could be split in such
    # a way, that the first part is valid
    # see https://hexdocs.pm/elixir/String.html#module-grapheme-clusters
    investigation_length = min(2 * @lookback_in_bytes, byte_size(string) - lookback_start)
    investigated_slice = binary_part(string, lookback_start, investigation_length)

    actual_length =
      split_into_maybe_incorrect_graphemes(investigated_slice)
      |> Enum.reduce_while(lookback_start, fn grapheme, cur_position ->
        case cur_position + byte_size(grapheme) do
          fits when fits <= length ->
            {:cont, fits}

          _overflows ->
            {:halt, cur_position}
        end
      end)

    {actual_length, binary_part(string, 0, actual_length)}
  end

  defp split_into_maybe_incorrect_graphemes(string) do
    string
    |> String.chunk(:valid)
    |> Enum.flat_map(fn chunk ->
      if String.valid?(chunk) do
        String.graphemes(chunk)
      else
        [chunk]
      end
    end)
  end
end
