# Impersonator

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x9D75AF88C98C2524600f20B614ee064aE356C19C)

目标是使ECLocker合约中的controller地址变为零地址

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/Impersonator -vvvvv
```

## 功能简述

要想改变`controller`的值，只能调用`changeController`函数，通过验证原始`controller`的签名，来修改`controller`地址。复用签名？

**可锻性攻击**（Malleability Attack），利用签名的数学特性以生成替代有效签名的攻击方式。它允许攻击者在不需要私钥的情况下修改签名，同时保持签名的有效性。这种攻击方式尤其可能在区块链网络中造成交易被重复执行的漏洞，称为**交易重放攻击**。

secp256k1曲线（用于以太坊和比特币的ECDSA签名）具有关于x轴的对称性，因此对每个有效签名(r, s)，可以通过计算(r，n-s)生成一个等效的签名。[其中“n” 指的是椭圆曲线上的一个特定参数——生成点 G 的阶。阶 n 表示将生成点重复加上自身 n 次后结果为零，通常称为曲线的“基点阶”或“生成点的阶”。] 对于 secp256k1 曲线，阶 n 是一个非常大的素数，数值为：

```
n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
```

这导致每个原始签名都会有两个可能的签名表现形式，这在验证环节不会被视为无效。这种特性使得攻击者能够在不更改交易内容的情况下改变签名格式，从而引起交易哈希的变化。虽然交易内容没变，但不同的哈希值让交易在某些系统中可能被视为新的交易，从而导致重复支付等问题。

为减少这种风险，以太坊通过EIP-2规范限制了s的范围，所有 s 值大于`secp256k1n/2`的交易签名都被视为无效。这样做减少了可接受的签名数量，确保对每个r值仅有一个有效的签名，从而避免了签名的可锻性问题。

**然而，若直接使用ecrecover函数且未限制s值，则仍可能出现漏洞。**

所以，解题思路就是eip-2中提到的。

> Allowing transactions with any s value with `0 < s < secp256k1n`, as is currently the case, opens a transaction malleability concern, as one can take any transaction, flip the s value from `s` to `secp256k1n - s`, flip the v value (`27 -> 28`, `28 -> 27`), and the resulting signature would still be valid. 

在OpenZeppelin的[ECDSA合约](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.1/contracts/utils/cryptography/ECDSA.sol#L134)中，也解释并限制了签名复用操作。

