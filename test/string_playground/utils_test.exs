defmodule StringPlayground.UtilsTest do
  use ExUnit.Case
  use ExUnitProperties

  alias StringPlayground.Utils

  doctest Utils

  property "generating an alphanumeric string of the given length generates the correct length" do
    check all(length <- integer(0..1000)) do
      str = Utils.generate_string(:alphanumeric, length)
      assert String.length(str) == length
    end
  end

  property "String.slice is equivalent to binary_part for alphanumeric inputs" do
    check all(
            str <- string(:alphanumeric),
            len = byte_size(str),
            start <- integer(0..len),
            sub_len <- integer(0..(len - start))
          ) do
      assert String.slice(str, start, sub_len) == binary_part(str, start, sub_len)
    end
  end

  describe "Palindrome checking with String.at" do
    property "is correct for alphanumeric graphemes" do
      check all(str <- string(:alphanumeric)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_string_at(str) == is_palindrome
      end
    end

    property "is correct for arbitrary graphemes" do
      check all(str <- string(:printable)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_string_at(str) == is_palindrome
      end
    end
  end

  describe "Palindrome checking with binary_part" do
    property "is correct for alphanumeric graphemes" do
      check all(str <- string(:alphanumeric)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_binary_part(str) == is_palindrome
      end
    end

    ## this approach doesn't work for arbitrary strings
    @tag :skip
    property "DOESN'T WORK: Palindrome checking with binary_part is correct for arbitrary graphemes" do
      check all(str <- string(:printable)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_binary_part(str) == is_palindrome
      end
    end
  end

  describe "Palindrome checking with String.graphemes/1" do
    property "is correct for alphanumeric graphemes" do
      check all(str <- string(:alphanumeric)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_graphemes(str) == is_palindrome
      end
    end

    property "is correct for arbitrary graphemes" do
      check all(str <- string(:printable)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_with_graphemes(str) == is_palindrome
      end
    end
  end

  describe "check_palind check_palindrome_charlist_optimized" do
    property "is correct for alphanumeric graphemes" do
      check all(str <- string(:alphanumeric)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_charlist_optimized(str) == is_palindrome
      end
    end
  end

  describe "check_palind check_palindrome_charlist" do
    property "is correct for alphanumeric graphemes" do
      check all(str <- string(:alphanumeric)) do
        is_palindrome = str == String.reverse(str)
        assert Utils.check_palindrome_charlist(str) == is_palindrome
      end
    end
  end
end
