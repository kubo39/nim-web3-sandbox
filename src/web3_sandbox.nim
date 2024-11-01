import
  std/json,
  chronos,
  json_rpc/client,
  results,
  stew/byteutils,
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

contract(Multiply7):
  proc multiply(input: UInt256): UInt256 {.view.}

const Multiply7Code = staticRead("../contractsBuild/Multiply7.bin")

proc doContract() {.async.} =
  let web3 = await newWeb3("ws://127.0.0.1:8545")
  let accounts = await web3.provider.eth_accounts()

  let value = 10000000.u256
  discard await web3.provider.anvil_setBalance(accounts[0], value)

  web3.defaultAccount = accounts[0]
  var tr: TransactionArgs
  tr.`from` = Opt.some(web3.defaultAccount)
  tr.data = Opt.some(hexToSeqByte(Multiply7Code))
  tr.gas = Opt.some Quantity(3000000)
  tr.gasPrice = Opt.some Quantity(3)
  let r = await web3.send(tr)
  let receipt = await web3.getMinedTransactionReceipt(r)
  echo receipt.status
  await web3.close

waitFor doContract()
