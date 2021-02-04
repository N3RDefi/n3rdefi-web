/**
 * @plugin $graphql
 * @extends Vue
 * @description My graphql helper plugin
 * @example
 *  this.$graphql()
 *  this.$graphql.getAccounts(account)
 */
import Vue from 'vue'
import { GraphQLClient, gql } from 'graphql-request'

/* Network Enum */
import { networks } from '../util/networks'

const network = networks.KOVAN_TEST_NET
console.log('Choosen Network', network.id)

/* Aave Contract Addresses */
const MAIN_MARKET_SUBGRAPH =
  network.id === 1
    ? 'https://thegraph.com/explorer/subgraph/aave/protocol-v2?version=current'
    : 'https://thegraph.com/explorer/subgraph/aave/protocol-v2-kovan'
const GOVERNANCE_SUBGRAPH =
  network.id === 1
    ? 'https://thegraph.com/explorer/subgraph/aave/governance-v2'
    : 'https://thegraph.com/explorer/subgraph/aave/governance-v2-kovan'

/* Base function to check the Ethereum Provider  */
const getQuery = () => {
  const query = gql`
    {
      reserves (where: {
        usageAsCollateralEnabled: true
      }) {
        id
        name
        price {
          id
        }
        liquidityRate
        variableBorrowRate
        stableBorrowRate
      }
    }
  `
  console.log('query:', query)
  return query
}
/* Base Aave helper to check provider -> USAGE: this.$aave()  */
const graphql = async () => {
  const graphQLClient = new GraphQLClient(MAIN_MARKET_SUBGRAPH, {
    origin: '*',
    changeOrigin: true,
    mode: 'cors',
    credentials: 'include'
  })
  const query = getQuery()
  try {
    const data = graphQLClient.request(query)
    console.log(JSON.stringify(data, undefined, 2))
    return data
  } catch (error) {
    console.error(JSON.stringify(error, undefined, 2))
    return null
  }
}
/* Loads the Aave Main Market Subgraph */
graphql.loadSubgraph = async () => {
  const graphQLClient = new GraphQLClient(MAIN_MARKET_SUBGRAPH, {
    origin: '*',
    changeOrigin: true,
    mode: 'cors',
    credentials: 'include'
  })
  const query = getQuery()
  try {
    const data = await graphQLClient.request(query)
    console.log(JSON.stringify(data, undefined, 2))
    return data
  } catch (error) {
    console.error(JSON.stringify(error, undefined, 2))
    return null
  }
}

/* Loads the Aave Governance Subgraph */
graphql.loadGovSubgraph = async () => {
  const graphQLClient = new GraphQLClient(GOVERNANCE_SUBGRAPH, {
    origin: '*',
    changeOrigin: true,
    mode: 'cors',
    credentials: 'include'
  })
  const query = getQuery()
  try {
    const data = await graphQLClient.request(query)
    console.log(JSON.stringify(data, undefined, 2))
    return data
  } catch (error) {
    console.error(JSON.stringify(error, undefined, 2))
    return null
  }
}

/* Setup Namespace */
graphql.install = (Vue) => {
  Vue.prototype.$graphql = graphql
}

/* Init */
Vue.use(graphql)
