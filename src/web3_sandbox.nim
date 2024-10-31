import
  std/json,
  chronos,
  json_rpc/client,
  web3

createRpcSigsFromNim(RpcClient):
  proc anvil_setBalance(address: Address, value: UInt256): JsonNode

proc ethGetBalance(): Future[UInt256] {.async.} =
  let web3 = await newWeb3("ws://127.0.0.1:8545")
  let accounts = await web3.provider.eth_accounts()
  let value = 1000.u256
  discard await web3.provider.anvil_setBalance(accounts[0], value)
  result = await web3.provider.eth_getBalance(accounts[0], "latest")
  await web3.close

echo waitFor ethGetBalance()
