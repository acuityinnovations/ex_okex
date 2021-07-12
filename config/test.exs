use Mix.Config

config :ex_okex,
  api_key: {:system, "OKEX_TEST_API_KEY"},
  # Base.encode64("OKEX_TEST_API_SECRET")
  api_secret: {:system, "R0RBWF9URVNUX0FQSV9TRUNSRVQ="},
  api_passphrase: {:system, "OKEX_TEST_API_PASSPHRASE"}

config :exvcr,
  filter_request_headers: [
    "OK-ACCESS-KEY",
    "OK-ACCESS-SIGN",
    "OK-ACCESS-TIMESTAMP",
    "OK-ACCESS-PASSPHRASE"
  ],
  filter_sensitive_data: [
    [pattern: "signature=[A-Z0-9]+", placeholder: "signature=***"]
  ]
