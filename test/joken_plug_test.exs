defmodule JokenPlugTest do
  use ExUnit.Case
  doctest JokenPlug

  test "greets the world" do
    assert JokenPlug.hello() == :world
  end
end
