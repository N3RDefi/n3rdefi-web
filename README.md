# N3RDefi

> Welcome to N3RDefi - A Defi g33k-o-system for N3RDs

What is N3RDefi?
N3RDefi is a SAFU environment, where fellow N3RDs can come together to form and be part of a community. Being part of a community offers trust, strength, safety and commitment to a united cause, this help reduce and even eliminate bad actors.

Once bad actors have been removed from a community, it allows for better growth and yields which can help grow the eco-system. Rewards can vary from kudos for good actions, like social interactions. In addition to various Defi protocols, N3RDefi offers other decentralised financial services like our smart vaults and deflationary yield farming.

## N3RD Diamond

The N3RD Diamond is firstly a unique NFT, in a simialr fashion to Cryptopuns or Crypto Kitties and Aavegotchi, but N3RDs are unique in the fact that they allow you to
benefit from your interactions within our g33k-o-system. Rewards can be issued in the form of N3rdy tokens, NFT's and experience which serves as weight so you can level up your N3RD and earn more in doing so.

Rewards earned for being a good player can be utilised throughout the N3RDefi ecosystem, for example to purchase NFT's in our NFT marketplace, these can get staked and either put up for sale or used as a blueprint for artists, so fellow N3RDs can buy a t-shirt, hoodie or cap with their favourite 8-Bit Art. Proceeds would be distributed back to NFT holders in the form of XP, tokens or various other prizes.

## SAFU Protocol

The SAFU Protocol ensures all funds are SAFU, with our smart vault locks, we ensure only legit players can interact with our main vaults and systems.

## Diamond 1 implementation by Author

The diamond standard and reference implementation were written by Nick Mudge.

Contact:

- https://twitter.com/mudgen
- nick@perfectabstractions.com

### Diamond Standard Reference Implementation

This is a reference implementation for [EIP-2535 Diamond Standard](https://github.com/ethereum/EIPs/issues/2535). To learn about other reference implementations go here: https://github.com/mudgen/diamond

**Note:** In this implementation the loupe functions are NOT gas optimized. The `facets`, `facetFunctionSelectors`, `facetAddresses` loupe functions are not meant to be called on-chain and may use too much gas or run out of gas when called in on-chain transactions. In this implementation these functions should be called by off-chain software like websites and Javascript libraries etc., where gas costs do not matter.

However the `facetAddress` loupe function is gas efficient and can be called in on-chain transactions.

The `contracts/Diamond.sol` file shows an example of implementing a diamond.

The `contracts/facets/DiamondCutFacet.sol` file shows how to implement the `diamondCut` external function.

The `contracts/facets/DiamondLoupeFacet.sol` file shows how to implement the four standard loupe functions.

The `contracts/libraries/LibDiamondStorage.sol` file shows how to implement Diamond Storage.

The `test/diamondTest.js` file gives tests for the `diamondCut` function and the Diamond Loupe functions.

### How to Get Started Making Your Diamond

1. The most important thing is reading and understanding the [Diamond Standard](https://github.com/ethereum/EIPs/issues/2535). If something is unclear let me know!

2. The second important thing is using an EIP-2535 Diamond Standard reference implementation. You are at the right place because this is the README for a diamond reference implementation.

A diamond reference implementation is more than a reference implementation. It is the boilerplate code you need for a diamond. Also, using a reference implementation ensures your diamond is compliant with EIP-2535 Diamond Standard.

Specifically you can copy and use the [DiamondCutFacet.sol](./contracts/facets/DiamondCutFacet.sol) and [DiamondLoupeFacet.sol](./contracts/facets/DiamondLoupeFacet.sol) contracts as is. They implement the `diamondCut` function and the loupe functions.

The [Diamond.sol](./contracts/Diamond.sol) contract could be used as is, or it could be used as a starting point and customized. This contract is the diamond. Its deployment creates a diamond. It's address is a stable diamond address that does not change.

The [LibDiamondStorage.sol](./contracts/libraries/LibDiamondStorage.sol) library could be used as is. It shows how to implement Diamond Storage. This contract includes contract ownership which you might want to change if you want to implement DAO-based ownership or other form of contract ownership. Go for it. Diamonds can work with any kind of contract ownership strategy.

The [LibDiamondCut.sol](./contracts/libraries/LibDiamondCut.sol) library contains an internal function version of `diamondCut` that can be used in the constructor of a diamond or other places.

#### Calling Diamond Functions

In order to call a function that exists in a diamond you need to use the ABI information of the facet that has the function.

Here is an example that uses web3.js:

```javascript
let myUsefulFacet = new web3.eth.Contract(MyUsefulFacet.abi, diamondAddress);
```

In the code above we create a contract variable so we can call contract functions with it.

In this example we know we will use a diamond because we pass a diamond's address as the second argument. But we are using an ABI from the MyUsefulFacet facet so we can call functions that are defined in that facet. MyUsefulFacet's functions must have been added to the diamond (using diamondCut) in order for the diamond to use the function information provided by the ABI of course.

Similarly you need to use the ABI of a facet in Solidity code in order to call functions from a diamond. Here's an example of Solidity code that calls a function from a diamond:

```solidity
string result = MyUsefulFacet(diamondAddress).getResult()
```

### Get Help and Join the Community

If you need help or would like to discuss diamonds then send me a message [on twitter](https://twitter.com/mudgen), or [email me](mailto:nick@perfectabstractions.com). Or join the [Diamond Standard Discord server](https://discord.gg/kQewPw2).

### Useful Links

1. [EIP-2535 Diamond Standard](https://github.com/ethereum/EIPs/issues/2535)
1. [Understanding Diamonds on Ethereum](https://dev.to/mudgen/understanding-diamonds-on-ethereum-1fb)
1. [Solidity Storage Layout For Proxy Contracts and Diamonds](https://medium.com/1milliondevs/solidity-storage-layout-for-proxy-contracts-and-diamonds-c4f009b6903)
1. [New Storage Layout For Proxy Contracts and Diamonds](https://medium.com/1milliondevs/new-storage-layout-for-proxy-contracts-and-diamonds-98d01d0eadb)
1. [Diamond Setter](https://github.com/lampshade9909/DiamondSetter)
1. [Upgradeable smart contracts using the Diamond Standard](https://hiddentao.com/archives/2020/05/28/upgradeable-smart-contracts-using-diamond-standard)
1. [buidler-deploy supports diamonds](https://github.com/wighawag/buidler-deploy/)

## Tech Stack

TECH STACK
Vue.js
Nuxt.js
Solidity
Ethereum
Hardhat
Matic

## Build Setup

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).
