defmodule StringPlayground.AdaptiveTest do
  use ExUnit.Case
  use ExUnitProperties

  alias StringPlayground.Adaptive

  doctest Adaptive

  describe "slice_beginning/2" do
    property "returns same thing as binary_part and String.slice when used on ascii strings" do
      check all(
        str <- string(:ascii),
        maybe_negative_length <- integer(),
        length = abs(maybe_negative_length)
      ) do
        string_slice = String.slice(str, 0, length)
        binary_part_slice = binary_part(str, 0, min(length, byte_size(str)))
        {_actual_length, adaptive_slice} = Adaptive.slice_beginning(str, length)

        assert string_slice == binary_part_slice
        assert string_slice == adaptive_slice
      end
    end

    property "returns a slice no longer than the passed length" do
      check all(
        str <- string(:printable),
        maybe_negative_length <- integer(),
        length = abs(maybe_negative_length)
      ) do
        {slice_length, slice} = Adaptive.slice_beginning(str, length)

        assert slice_length <= length
        assert slice_length == byte_size(slice)
      end
    end

    property "maintains the graphemes between and after the split" do
      check all(
        str <- string(:printable),
        length <- integer(0..byte_size(str))
      ) do
        input_length = byte_size(str)
        {slice_length, slice} = Adaptive.slice_beginning(str, length)

        graphemes_before = String.graphemes(str)
        graphemes_after = String.graphemes(slice) ++ String.graphemes(binary_part(str, slice_length, input_length - slice_length))
        assert graphemes_before == graphemes_after
      end
    end

    property "couldn't add more graphemes without going over the length" do
      check all(
        str <- string(:printable, min_length: 1),
        length <- integer(0..(byte_size(str) - 1))
      ) do
        input_length = byte_size(str)
        {slice_length, slice} = Adaptive.slice_beginning(str, length)

        slice_graphemes = String.graphemes(slice)
        remaining_graphemes = String.graphemes(binary_part(str, slice_length, input_length - slice_length))

        slice_with_extra_grapheme = slice_graphemes ++ Enum.take(remaining_graphemes, 1)
        expanded_slice = Enum.join(slice_with_extra_grapheme)

        assert byte_size(expanded_slice) > slice_length

        # just to make sure the test code is correct
        assert String.starts_with?(str, expanded_slice)
      end
    end
  end
end
