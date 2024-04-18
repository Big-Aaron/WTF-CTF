# Stake

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xB99f27b94fCc8b9b6fF88e29E1741422DFC06224)

需要达成4个条件

- `Stake` 合约的ETH余额必须大于0。
- `totalStaked` 必须大于 `Stake` 合约的 ETH 余额。
- 我们的账户地址必须为质押者。
- 我们质押的余额必须为 0。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Stake -vvvvv
```

## 功能简述

`Stake`合约接受两种资产的质押，`ETH`和`WETH`。虽然两种资产在价值上是1:1等价的。但是`WETH`是`ETH链`原生代币的`ERC20`包装的版本（具体信息可以查看WTF-Solidity的[41节WETH](https://github.com/AmazingAng/WTF-Solidity/blob/main/41_WETH/readme.md)）。

但是`Stake`合约中将`ETH`和`WETH`混为一谈。如果我们质押的是`WETH`，提取的却是`ETH`（`Stake`合约并没有将 `WETH`兑换为`ETH`，`Stake`合约某种程度上成为了`ETH`/`WETH`交易对）。

所以，我们质押`WETH`，提取`ETH`。就可以把`Stake`合约的`ETH`全部提取出来。

而且，`Stake`合约在转移质押者的`WETH`代币时，并没有判断转移交易是否成功，所以，我们只需要在`WETH`代币中对`Stake`合约进行授权就好，我们实际有没有`WETH`代币并不重要。

先质押`WETH`，在提取`ETH`，就可以把我们的质押余额清零。

题目的其他两个条件

- `Stake` 合约的ETH余额必须大于0。
- `totalStaked` 必须大于 `Stake` 合约的 ETH 余额。

我们只需不提取完其他账户质押的ETH就好（为了完成题目，我们也可以切换个地址进行质押）。