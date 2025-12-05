## Contracts

- [ERC-4626](./lib/solmate/src/tokens/ERC4626.sol)
- [AVAVault](./src/Vault/AVAVault.sol)
- [AAVEStrategy](./src/Vault/Stratagies/AAVEStrategy.sol)
- [BenqiStrategy](./src/Vault/Stratagies/BenqiStrategy.sol)
- [EulerStrategy](./src/Vault/Stratagies/EulerStrategy.sol)
- [WAVAX](./src/Vault/Mocks/MockWAVAX.sol)



## Run
1. 
```bash
forge install
```
2. 
```bash
forge build
```
3. 
```bash
forge test
```
4. 
```bash
forge coverage
```

## Deploy

Avalanche Mainet

```bash
forge script scripts/deployAVAVault.s.sol:deployAVAVault --rpc-url <RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast --etherscan-api-key <YOUR_ETHERSCAN_API_KEY> --verify
```

Avalanche Fuji Testnet

```bash
forge script scripts/deployAVAVault.s.sol:deployAVAVault --rpc-url <RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast --etherscan-api-key <YOUR_ETHERSCAN_API_KEY> --verify
```

## Agents

1. Oracle Specialist (Nova)

Agent Nft - https://testnet.snowtrace.io/nft/0x9FC0C2E42d698B177853660fbb12B6A53A26B5DC/2?chainid=43113&type=erc721

2. Vault Manager (Aria)

Agent Nft - https://testnet.snowtrace.io/nft/0x9FC0C2E42d698B177853660fbb12B6A53A26B5DC/1?chainid=43113&type=erc721

## Fuji Deployments

### ERC 8004

1. Deployed ERC 8004

``` bash

  IdentityRegistry:    0x9FC0C2E42d698B177853660fbb12B6A53A26B5DC
  ReputationRegistry:  0x38D08c148741ddb3df131EE134738F356948E67d
  ValidationRegistry:  0x2694f3Af9603Bc70c2D0e7F345185111E9dDaE4C

```
2. Agents Created

```bash
  Registry Address: 0x9FC0C2E42d698B177853660fbb12B6A53A26B5DC
  Aria registered with Agent ID: 1
  Nova registered with Agent ID: 2

```

## Vault

```bash

WAVAX Asset : 0xd00ae08403B9bbb9124bB305C09058E32C39A48c

AVAVault    : 0xA78B8d6992cb4a094CFBCc74EB79b35e1eB09b75

Aave Strat  : 0xFCD5639Cd495f6c86c71Cf6a076720F72De51489
Euler Strat : 0x0Fde830AC40B7D7f43316e4F1B445FdF464932D3
Benqi Strat : 0x25542EF879057142622d3491B459624a4Ac2efD3

```

## Tests

```bash
forge test
[⠑] Compiling...
[⠘] Compiling 1 files with Solc 0.8.30
[⠃] Solc 0.8.30 finished in 999.12ms
Compiler run successful!

Ran 22 tests for test/AVAVault.t.sol:AVAXVaultTest
[PASS] test_AccessControl_AddStrategy() (gas: 14380)
[PASS] test_AccessControl_Rebalance() (gas: 89344)
[PASS] test_AccessControl_RemoveStrategy() (gas: 87599)
[PASS] test_AccessControl_UpdateActiveStrategy() (gas: 87597)
[PASS] test_CannotAddDuplicateStrategy() (gas: 85264)
[PASS] test_CannotAddWrongAssetStrategy() (gas: 1263091)
[PASS] test_CannotAddZeroAddressStrategy() (gas: 9668)
[PASS] test_DepositZero() (gas: 27322)
[PASS] test_Rebalance_InsufficientFunds() (gas: 98750)
[PASS] test_Rebalance_LeavesRemainderInVault() (gas: 305252)
[PASS] test_Rebalance_UnregisteredTarget() (gas: 197546)
[PASS] test_Rebalance_Validation() (gas: 86332)
[PASS] test_RemoveStrategy_PullsFundsAndResetsActive() (gas: 259061)
[PASS] test_Staking_InitialExchangeRate() (gas: 232855)
[PASS] test_Staking_Mint_CalculatesCostCorrectly() (gas: 349783)
[PASS] test_Staking_PreviewFunctionsAccuracy() (gas: 247072)
[PASS] test_Staking_TransferAndRedeem() (gas: 296294)
[PASS] test_Staking_YieldIncreasesSharePrice() (gas: 277727)
[PASS] test_UpdateActiveStrategy_MustBeRegistered() (gas: 13998)
[PASS] test_WithdrawWithInsufficientLiquidity() (gas: 284973)
[PASS] test_Withdrawal_LIFO_Order() (gas: 406312)
[PASS] test_Withdrawal_SkipsEmptyStrategies() (gas: 454260)
Suite result: ok. 22 passed; 0 failed; 0 skipped; finished in 11.49ms (10.38ms CPU time)

Ran 1 test suite in 21.35ms (11.49ms CPU time): 22 tests passed, 0 failed, 0 skipped (22 total tests)
```

## Coverage

```bash
╭----------------------------------------+-----------------+------------------+----------------+----------------╮
| File                                   | % Lines         | % Statements     | % Branches     | % Funcs        |
+===============================================================================================================+
|----------------------------------------+-----------------+------------------+----------------+----------------|
| src/Vault/AVAVault.sol                 | 100.00% (81/81) | 97.87% (92/94)   | 90.32% (28/31) | 100.00% (9/9)  |
|----------------------------------------+-----------------+------------------+----------------+----------------|
| src/Vault/Mocks/MockWAVAX.sol          | 100.00% (2/2)   | 100.00% (1/1)    | 100.00% (0/0)  | 100.00% (1/1)  |
|----------------------------------------+-----------------+------------------+----------------+----------------|
| src/Vault/Stratagies/AAVEStrategy.sol  | 100.00% (13/13) | 100.00% (9/9)    | 50.00% (2/4)   | 100.00% (5/5)  |
╰----------------------------------------+-----------------+------------------+----------------+----------------╯
```

## Strategy Sources

1. AAVE V3 
2. Benqi Lending,
3. Euler Finance