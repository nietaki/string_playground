defmodule StringPlayground.UtilsTest do
  use ExUnit.Case
  use ExUnitProperties

  alias StringPlayground.Utils

  doctest Utils

  property "generating an alphanumeric string of the given length generates the correct length" do
    check all length <- integer(0..1000) do
      str = Utils.generate_string(:alphanumeric, length)
      assert String.length(str) == length
    end
  end

  property "String.slice is equivalent to binary_part for alphanumeric inputs" do
  check all str <- string(:alphanumeric),
            len = byte_size(str),
            start <- integer(0..len),
            sub_len <- integer(0..(len-start)) do
      assert String.slice(str, start, sub_len) == binary_part(str, start, sub_len)
    end
  end
end
