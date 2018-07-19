defmodule Joken.Issuer.Test do
  use ExUnit.Case
  doctest Joken.Issuer

  test "The struct allows for an issuer ID" do
    assert %Joken.Issuer{iss: "hi"}
  end

  test "The struct allows for a primitive encyption algorithm specification" do
    assert %Joken.Issuer{iss: "hi", alg: "ES512"}
  end

  test "The struct also allows for a function in the alg spot" do
    myFunc = fn -> "hello" end
    assert %Joken.Issuer{iss: "hi", alg: myFunc}
  end

  test """
  There is a realize config function that
  if the `alg` is a function will return the result of running
  that function
  """ do
    myFunc = fn -> "hello" end

    result = Joken.Issuer.realize(%Joken.Issuer{iss: "hi", alg: myFunc})

    assert result.alg === "hello"
  end

  test "There is a realize config function that can turn the struct into a final config" do
    result = Joken.Issuer.realize(%Joken.Issuer{iss: "hi", alg: "ES512"})

    assert result.alg === "ES512"
  end
end
