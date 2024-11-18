# MagicAnimalCarousel

## 题目描述

[原题 in Sepolia](https://ethernaut.openzeppelin.com/level/0x68839EDF716D5Ba1fb5C1e724bF160B23fa523b5)

目标是使MagicAnimalCarousel合约中再添加“Animal”时，将“Animal”的名称发生变化。

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令：

```sh
$ cd WTF-CTF

$ forge test -C src/Ethernaut/MagicAnimalCarousel -vvvvv
```

## 功能简述

`MagicAnimalCarousel`合约中的`carousel` 映射，使用一个 `uint256` 变量存储新的动物编码、下一个动物的ID，以及调用者的地址。

- 存储结构
  - **位 176-255（80 位）**：动物编码。
  - **位 160-175（16 位）**：下一个动物ID。
  - **位 0-159（160 位）**：所有者地址。

但是，在`MagicAnimalCarouse`l合约中的`changeAnimal`函数中，用户在修改动物名称时，并没有将动物编码左移160+16位，而是左移了160位，使得我们可以通过操控动物名称，进而修改动物的编号，而动物最多有`type(uint16).max)`【0xffff】这么多，且在合约中记录动物编号的变量`nextCrateId`又是以`uint256`的变量进行存储的，所以编号可以发生上溢出。

攻击思路：

1. 我们加入一个名为“WTF”动物，获得编号1。
2. 修改编号1的动物名称为“ffffffffffffffffffffffff”【24位=20位名称+4位的下一个动物编号】。
3. 再加入名为“WTF”动物，获得编号0xffff。
4. 这样再加入“Goat”时，会获得编号1，再计算“Goat”的`animalInside`时的`carousel[nextCrateId]`不为空，就会获得脏数据【最早加入的“WTF”的数据】，从而将“Goat”计算后名称发生变化。

