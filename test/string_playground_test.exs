defmodule StringPlaygroundTest do
  use ExUnit.Case
  doctest StringPlayground

  test "greets the world" do
    assert StringPlayground.hello() == :world
  end
end
