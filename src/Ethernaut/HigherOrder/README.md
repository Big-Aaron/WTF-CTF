# HigherOrder

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0xd459773f02e53F6e91b0f766e42E495aEf26088F)

目标是使我们的账户地址成为合约中的commander。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/HigherOrder -vvvvv
```

## 功能简述

要想改变`commander`变量，只能让`treasury`变量大于255。而改变`treasury`变量只能通过`registerTreasury(uint8)`函数。

而`registerTreasury函数`中在改变`treasury`变量时，是直接读取了我们交易调用calldata的第4个字节后的32字节数据。然后将这32字节的数据写入了`treasury`变量所在的插槽。（calldata的前4个字节为函数签名selector）

所以，我们只需调用`registerTreasury函数`,并在`calldata`的`selector`后拼接`treasury`变量的值（例如，修改为`type(uint256).max`）

```solidity
abi.encodeWithSignature("registerTreasury(uint8)", type(uint256).max)
```

虽然`registerTreasury函数`接受的是`uint8`的变量，但是，函数逻辑里却是使用`calldataload`读取了32字节的数据。只需要`calldata`前4个字节的selector正确 ，就可以调用`registerTreasury函数`。