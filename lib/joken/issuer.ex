defmodule Joken.Issuer do
  @enforce_keys [:iss]

  defstruct [
    :iss,
    :alg
  ]

  def sample_jwt() do
    "eyJhbGciOiJFUzUxMiJ9.eyJ1c2VyIjp7ImVtcGxveWVlX2lkIjo3MzQyLCJlbXBsb3llZV9udW1iZXIiOiI3OTYxIiwiZW1haWwiOiJtYXR0aGV3LmhlY2tlckBibHVlYXByb24uY29tIiwiZmFjaWxpdHlfaWQiOm51bGwsInJvbGVzIjpbIkNvcnBvcmF0ZSBNYW5hZ2VyIl19LCJpYXQiOjE1MzE5NDY5MTksImlzcyI6IldNUyIsImF1ZCI6InN0YWdpbmciLCJleHAiOjE1MzE5NTA1MTksImp0aSI6IjI5NTIxOThjLTBiZmYtNGE0YS1hZGVlLTBjNDAwMjJhMGQwNSJ9.AdW8qHj_sh0xb9LUbq6WeBtScKnp4udtEFDmqAQzuABKRXAHgpukn8RMnSO67yTnXJ9iRT_1SQUPvWzoifMRCd2NAZf0uFm7oCvVoVdDmOrzOQ4US7q6fuGDW31s3UNHY8twI3gS7YKDea87y_KT-dM_1Gi5YOehJiiI3R-M_0KSt2Et"
  end

  def go() do
    import Joken
    verify(token(sample_jwt), get_signer(sample_jwt))
  end

  def get_signer(jwt) do
    import Joken
    import JOSE.JWK

    config = find_config_by(jwt)

    config.alg.(config.secret.())
  end

  def find_config_by(jwt) do
    headers_and_claims(jwt)
    
    some_config()
    |> Enum.find(&(map_match(&1.claims, headers_and_claims(jwt))))
  end

  def map_match(map1, map2) do
    map1
    |> Enum.all?(fn {key, value} -> Map.get(map2, to_string(key)) === value end)
  end

  defp headers_and_claims(jwt) do
    import Joken
    
    headers = token(jwt)
    |> peek_header

    claims = token(jwt)
    |> peek

    Map.merge(headers, claims)
  end


  def some_config() do
    import JOSE.JWK
    import Joken
    [
      %{
        headers: %{},
        claims: %{ jti: "2952198c-0bff-4a4a-adee-0c40022a0d05" },
        alg: &es512/1,
        secret: fn -> from_pem(
        "-----BEGIN PUBLIC KEY-----\nMIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQBcwcDt95j4NfkzY+TznrZW4j/COgz\nhQHlNcLUrCWYD2iZOAMk5kxyhpHX83l9z1dhghYoC2DkEcF5yM/WlqcvyxUBolZt\npyx2SgadY4ctFU9Nrn5nF7/uJUFPLr4MoYBr+zig+IO+DGVS+3Mu7YKFxQ8EqZKP\n3mgLSuf3gF4/QjkV2p8=\n-----END PUBLIC KEY-----"
      ) end
      }
    ]
  end

  def realize(%{iss: iss, alg: alg}) do
    %{
      iss: realize(iss),
      alg: realize(alg)
    }
  end

  def realize(entity) when is_function(entity), do: entity.()
  def realize(entity), do: entity
end

# wms_signer = es512(my_pem)
