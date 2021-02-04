/**
 * @plugin $web3
 * @extends Vue
 * @description My web3 helper plugin
 * @example
 *  this.$web3()
 *  this.$web3.getAccounts(account)
 */
import Vue from 'vue'
import { ethers } from "ethers"
import { TxBuilderV2, Network, Market  } from '@aave/protocol-js'
/* Contracts ABI */
// import AAVE_ABI from '../contracts/abi/AAVE_ABI'
/* Network Enum */
import { networks } from '../util/networks'

const network = networks.KOVAN_TEST_NET
console.log('Choosen Network', network.id)
console.log('Network: ', Network)
console.log('Aave Market', Market)
console.log('TxBuilderV2', TxBuilderV2)

/* Aave Contract Addresses */
const LENDINGPOOLADDRESSESPROVIDER =
  network.id === 1
    ? process.env.AAVE_LENDINGPOOLADDRESSESPROVIDER
    : process.env.AAVE_DEV_LENDINGPOOLADDRESSESPROVIDER
const LENDINGPOOLADDRESSESPROVIDERREGISTRY =
  network.id === 1
    ? process.env.AAVE_LENDINGPOOLADDRESSESPROVIDERREGISTRY
    : process.env.AAVE_DEV_LENDINGPOOLADDRESSESPROVIDERREGISTRY
const LENDINGPOOL =
  network.id === 1
    ? process.env.AAVE_LENDINGPOOL
    : process.env.AAVE_DEV_LENDINGPOOL
const LENDINGPOOLCOLLATERALMANAGER =
  network.id === 1
    ? process.env.AAVE_LENDINGPOOLCOLLATERALMANAGER
    : process.env.AAVE_DEV_LENDINGPOOLCOLLATERALMANAGER
const LENDINGPOOLCONFIGURATOR =
  network.id === 1
    ? process.env.AAVE_LENDINGPOOLCONFIGURATOR
    : process.env.AAVE_DEV_LENDINGPOOLCONFIGURATOR
const LENDINGRATEORACLE =
  network.id === 1
    ? process.env.AAVE_LENDINGRATEORACLE
    : process.env.AAVE_DEV_LENDINGRATEORACLE
const PRICEORACLE =
  network.id === 1
    ? process.env.AAVE_PRICEORACLE
    : process.env.AAVE_DEV_PRICEORACLE
const POOLADMIN =
  network.id === 1
    ? process.env.AAVE_POOLADMIN
    : process.env.AAVE_DEV_POOLADMIN
const EMERGENCYADMIN =
  network.id === 1
    ? process.env.AAVE_EMERGENCYADMIN
    : process.env.AAVE_DEV_EMERGENCYADMIN
const PROTOCOLDATAPROVIDER =
  network.id === 1
    ? process.env.AAVE_PROTOCOLDATAPROVIDER
    : process.env.AAVE_DEV_PROTOCOLDATAPROVIDER
const WETHGATEWAY =
  network.id === 1
    ? process.env.AAVE_WETHGATEWAY
    : process.env.AAVE_DEV_WETHGATEWAY
const COLLECTOR_CONTRACT =
  network.id === 1
    ? process.env.AAVE_COLLECTOR_CONTRACT
    : process.env.AAVE_DEV_COLLECTOR_CONTRACT

console.log("LENDINGPOOLADDRESSESPROVIDER", LENDINGPOOLADDRESSESPROVIDER)
console.log("LENDINGPOOLADDRESSESPROVIDERREGISTRY", LENDINGPOOLADDRESSESPROVIDERREGISTRY)
console.log("LENDINGPOOL", LENDINGPOOL)
console.log("LENDINGPOOLCOLLATERALMANAGER", LENDINGPOOLCOLLATERALMANAGER)
console.log("LENDINGPOOLCONFIGURATOR", LENDINGPOOLCONFIGURATOR)
console.log("LENDINGRATEORACLE", LENDINGRATEORACLE)
console.log("PRICEORACLE", PRICEORACLE)
console.log("POOLADMIN", POOLADMIN)
console.log("EMERGENCYADMIN", EMERGENCYADMIN)
console.log("PROTOCOLDATAPROVIDER", PROTOCOLDATAPROVIDER)
console.log("WETHGATEWAY", WETHGATEWAY)
console.log("COLLECTOR_CONTRACT", COLLECTOR_CONTRACT)

const getInterestRates = () => {
  return {
    None: 'None',
    Stable: 'Stable',
    Variable: 'Variable',
  }
}
console.log('getInterestRates', getInterestRates)

/* Base function to check the Ethereum Provider  */
const getProvider = async () => {
  const ethersProvider = new ethers.providers.Web3Provider(window.ethereum)
  if (ethersProvider) {
    return ethersProvider
  }
  console.error('Please check Aave provider to continue!')
  return null
}
/* Base Aave helper to check provider -> USAGE: this.$aave()  */
const aave = async () => {
  const httpProvider = await getProvider()
  return httpProvider
}
/* Get all lending pool methods */
aave.loadAavenomics = async () => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.mainnet, httpProvider)
  const faucet = txBuilder.faucetService
  return faucet
}
/* --- Lending Pool V2 --- */
/* Get all lending pool methods */
aave.lendingPool = async () => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.mainnet, httpProvider)
  const lendingPool = txBuilder.getLendingPool(Market.main)
  return lendingPool
}
/* Get all lending pool methods */
aave.lendingPoolsAll = async () => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const lendingPools = await txBuilder.getLendingPool(Market.main)
  return lendingPools
}
/* Lending pool deposit method
 * Deposits the underlying asset into the reserve. A corresponding amount of the overlying asset (aTokens) is minted.
 * @param user The ethereum address that will make the deposit
 * @param reserve The ethereum address of the reserve
 * @param amount The amount to be deposited
 * @param @optional onBehalfOf The ethereum address for which user is depositing. It will default to the user address
 * @param @optional referralCode Integrators are assigned a referral code and can potentially receive rewards. It defaults to 0 (no referrer)
 * If the user is not approved, an approval transaction will also be returned.
 */
aave.lendingPoolDeposit = async (user, reserve, amount, onBehalfOf, referralCode ) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const lendingPool = await txBuilder.getLendingPool(Market.main)
  const deposit = lendingPool.deposit({
    user, // string,
    reserve, // string,
    amount, // string,
    onBehalfOf, // ? string,
    referralCode, // ? string,
  })
  return deposit
}
/* Lending pool borrow method
 * Borrow an amount of reserve asset.
 * User must have a collaterised position (i.e. aTokens in their wallet)
 * @param user The ethereum address that will receive the borrowed amount
 * @param reserve The ethereum address of the reserve asset
 * @param amount The amount to be borrowed, in human readable units (e.g. 2.5 ETH)
 * @param interestRateMode Whether the borrow will incur a stable or variable interest rate (1 | 2)
 * @param @optional debtTokenAddress The ethereum address of the debt token of the asset you want to borrow. Only needed if the reserve is ETH mock address
 * @param @optional onBehalfOf The ethereum address for which user is borrowing. It will default to the user address
 * @param @optional refferalCode Integrators are assigned a referral code and can potentially receive rewards. It defaults to 0 (no referrer)
 */
aave.lendingPoolBorrow = async (user, reserve, amount, interestRateMode, debtTokenAddress, onBehalfOf, referralCode ) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const lendingPool = await txBuilder.getLendingPool(Market.main)
  const borrow = lendingPool.borrow({
    user, // string,
    reserve, // string,
    amount, // string,
    interestRateMode, // InterestRate
    debtTokenAddress, // ? string
    onBehalfOf, // ? string
    referralCode, // ? string
 })
  return borrow
}
/* Repays a borrow on the specific reserve, for the specified amount (or for the whole amount,
 * if (-1) is specified). the target user is defined by onBehalfOf. If there is no repayment on
 * behalf of another account, onBehalfOf must be equal to user.
 * @param user The ethereum address that repays
 * @param reserve The ethereum address of the reserve on which the user borrowed
 * @param amount The amount to repay, or (-1) if the user wants to repay everything
 * @param interestRateMode Whether the borrow will incur a stable or variable interest rate (1 | 2)
 * @param @optional onBehalfOf The ethereum address for which user is repaying. It will default to the user address
 * enum InterestRate {
 *  None = 'None',
 *  Stable = 'Stable',
 *  Variable = 'Variable',
 * }
 * If the user is not approved, an approval transaction will also be returned.
 */
aave.lendingPoolRepay = async (user, reserve, amount, interestRateMode, onBehalfOf ) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const lendingPool = await txBuilder.getLendingPool(Market.main)
  const repay = lendingPool.repay({
    user, // string,
    reserve, // string,
    amount, // string,
    interestRateMode, // InterestRate
    onBehalfOf, // ? string
 })
  return repay
}
/* Withdraws the underlying asset of an aToken asset.
 * @param user The ethereum address that will receive the aTokens
 * @param reserve The ethereum address of the reserve asset
 * @param amount The amount of aToken being redeemed
 * @param @optional aTokenAddress The ethereum address of the aToken. Only needed if the reserve is ETH mock address
 * @param @optional onBehalfOf The amount of aToken being redeemed. It will default to the user address
 */
aave.lendingPoolWithdraw = async (user, reserve, amount, aTokenAddress, onBehalfOf ) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const lendingPool = await txBuilder.getLendingPool(Market.main)
  const withdraw = lendingPool.withdraw({
    user, // string,
    reserve, // string,
    amount, // string,
    aTokenAddress, // ? string,
    onBehalfOf, // ? string
 })
  return withdraw
}
/* --- END Lending Pool V2 --- */

/* ------------------------------------------------------------------------------------------ */

/* --- Governance V2 --- */
/* Creates a Proposal (needs to be validated by the Proposal Validator)
 * @param user The ethereum address that will create the proposal
 * @param targets list of contracts called by proposal's associated transactions
 * @param values list of value in wei for each propoposal's associated transaction
 * @param signatures list of function signatures (can be empty) to be used when created the callData
 * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
 * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
 * @param ipfsHash IPFS hash of the proposal
 * @param executor The ExecutorWithTimelock contract that will execute the proposal
 */
aave.createGovernance = async (user, targets, values, signatures, calldatas, withDelegateCalls, ipfsHash, executor) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const gov2 = await txBuilder.aaveGovernanceV2Service
  // enum ExecutorType {
  //   Short,
  //   Long,
  // }
  const powerDelegation = gov2.create({
    user, // string
    targets, // string[]
    values, // string[]
    signatures, // string[]
    calldatas, // BytesLike[]
    withDelegateCalls, // boolean[]
    ipfsHash, // BytesLike
    executor, // ExecutorType
  })
  return powerDelegation
}
/* Cancels a Proposal. Callable by the _guardian with relaxed conditions, or by anybody
 * if the conditions of cancellation on the executor are fulfilled
 * @param user The ethereum address that will create the proposal
 * @param proposalId Id of the proposal we want to cancel
 */
aave.cancelGovernance = async (user, proposalId) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const gov2 = await txBuilder.aaveGovernanceV2Service
  const powerDelegation = gov2.cancel({
    user, // string
    proposalId, // number
  })
  return powerDelegation
}
/* Queue the proposal (If Proposal Succeeded)
 * @param user The ethereum address that will create the proposal
 * @param proposalId Id of the proposal we want to queue
 */
aave.queueGovernance = async (user, proposalId) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const gov2 = txBuilder.aaveGovernanceV2Service
  const powerDelegation = gov2.queue({
    user, // string
    proposalId, // number
  })
  return powerDelegation
}
/* Execute the proposal (If Proposal Queued)
 * @param user The ethereum address that will create the proposal
 * @param proposalId Id of the proposal we want to execute
 */
aave.executeGovernance = async (user, proposalId) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const gov2 = await txBuilder.aaveGovernanceV2Service
  const powerDelegation = gov2.execute({
    user, // string
    proposalId, // number
  })
  return powerDelegation
}
/* submitVote - Function allowing msg.sender to vote for/against a proposal
 * @param user The ethereum address that will create the proposal
 * @param proposalId Id of the proposal we want to vote
 * @param support Bool indicating if you are voting in favor (true) or against (false)
 */
aave.submitVoteGovernance = async (user, proposalId, support) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const gov2 = await txBuilder.aaveGovernanceV2Service
  const powerDelegation = gov2.submitVote({
    user, // string
    proposalId, // number
    support, // boolean
  })
  return powerDelegation
}
/* --- END Governance V2 --- */

/* ------------------------------------------------------------------------------------------ */

/* --- Governance Delegation --- */
/* Delegate Method for the user to delegate voting and proposition power to the chosen address
 * @param user The ethereum address that will create the proposal
 * @param delegatee The ethereum address to which the user wants to delegate proposition power and voting power
 * @param governanceToken The ethereum address of the governance token
 */
aave.delegate = async (user, delegatee, governanceToken) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const powerDelegation = await txBuilder.governanceDelegationTokenService
  const delegation = powerDelegation.delegate({
    user, // string
    delegatee,  // string
    governanceToken // string
  })
  return delegation
}
/* Method for the user to delegate voting or proposition power to the chosen address
 * @param user The ethereum address that will create the proposal
 * @param delegatee The ethereum address to which the user wants to delegate proposition power and voting power
 * @param delegationType The type of the delegation the user wants to do: voting power ('0') or proposition power ('1')
 * @param governanceToken The ethereum address of the governance token
 */
aave.delegateByType = async (user, delegatee, delegationType, governanceToken) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const powerDelegation = await txBuilder.governanceDelegationTokenService
  const delegation = powerDelegation.delegateByType({
    user, // string
    delegatee,  // string
    delegationType, // string
    governanceToken // string
  })
  return delegation
}
/* --- END Governance Delegation --- */

/* ------------------------------------------------------------------------------------------ */

/* --- Faucets --- */
/* To use the testnet faucets which are compatible with Aave: */
aave.faucets = async () => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const faucets = await txBuilder.faucetService
  return faucets
}
/* Mint tokens for the usage on the Aave protocol on the Kovan network.
 * The amount of minted tokens is fixed and depends on the token
 * @param userAddress The ethereum address of the wallet the minted tokens will go
 * @param reserve The ethereum address of the token you want to mint
 * @param tokenSymbol The symbol of the token you want to mint
 */
aave.mint = async (userAddress, reserve, tokenSymbol) => {
  const httpProvider = await getProvider()
  const txBuilder = new TxBuilderV2(Network.main, httpProvider)
  const faucet = await txBuilder.faucetService
  const brrrr = faucet.mint({
    userAddress, // string
    reserve, // string
    tokenSymbol, // string
  })
  return brrrr
}
/* --- END Faucets --- */

/* Setup Namespace */
aave.install = (Vue) => {
  Vue.prototype.$aave = aave
}

/* Init */
Vue.use(aave)
