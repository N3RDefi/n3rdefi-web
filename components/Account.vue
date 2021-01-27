<template>
  <q-card flat bordered class="n3rd-card n3rd-account-card">
    <q-card-section>
      <div class="text-h6">
        {{ title }}
      </div>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>Account: {{ user.account[0] }}</p>
      <p>Balance: {{ user.balance }}</p>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>Web3 Instance: {{ user.web3Instance }}</p>
      <p>Is MetaMask: {{ user.isMetaMask }}</p>
      <p>Chain Id HEX: {{ user.chainIdHEX }}</p>
      <p>Network ID: {{ networkFilter(user.chainIdHEX, 'id') }}</p>
      <p>Network: {{ networkFilter(user.chainIdHEX, 'name') }}</p>
    </q-card-section>
    <q-card-section>
      <q-btn
        v-if="user"
        outline
        color="grey-8"
        class="full-width q-mb-sm"
        @click="
          sendTransaction(
            (from = 'test'),
            (to = 'test'),
            (value = 'test'),
            (gas = 'test'),
            (gasPrice = 'test')
          )
        "
      >
        Send Transaction
      </q-btn>
      <q-btn
        v-if="user"
        outline
        color="primary"
        class="full-width"
        @click="requestPermissions()"
      >
        Request Permissions
      </q-btn>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <pre>User: {{ user }}</pre>
    </q-card-section>
  </q-card>
</template>
<script>
import { networkFilter } from '../util/networkFilter'

export default {
  name: 'Account',
  props: {
    user: {
      type: Object,
      required: false,
      default: () => ({}),
    },
  },
  data() {
    return {
      title: 'Account',
    }
  },
  methods: {
    networkFilter(chainId, filterType) {
      return networkFilter(chainId, filterType)
    },
    async sendTransaction(from, to, value, gas, gasPrice) {
      try {
        const sent = await this.$web3.sendTransaction(
          from,
          to,
          value,
          gas,
          gasPrice
        )
        // Handle the result
        console.log(sent)
      } catch (error) {
        // Handle the error
        console.error(error)
      }
    },
    async requestPermissions() {
      await window.ethereum
        .request({
          method: 'eth_requestAccounts',
          params: [{ eth_accounts: {} }],
        })
        .then((permissions) => {
          const accountsPermission = permissions.find(
            (permission) => permission.parentCapability === 'eth_accounts'
          )
          if (accountsPermission) {
            console.log('eth_accounts permission successfully requested!')
          }
        })
        .catch((error) => {
          if (error.code === 4001) {
            // EIP-1193 userRejectedRequest error
            console.log('Permissions needed to continue.')
          } else {
            console.error(error)
          }
        })
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-account-card
  background-color: $white

/* CSS Media Queries */
/* $breakpoint-xl: 2400px */
@media only screen and (max-width: 2400px)
  .hide-on-bigscreen
    display: none

/* $breakpoint-lg:  1199px */
@media only screen and (max-width: 1199px)
  .hide-on-tablet
    display: none

/* $breakpoint-md: 1023px */
@media only screen and (max-width: 1023px)
  .hide-on-tablet
    display: none

/* $breakpoint-md: 959px */
@media only screen and (max-width: 959px)
  .hide-on-mobile
    display: none

/* $breakpoint-sm: 839px */
@media only screen and (max-width: 839px)
  .hide-on-mobile
    display: none

/* $breakpoint-xs: 479px */
@media only screen and (max-width: 479px)
  .hide-on-mobile
    display: none

// This is for old phone screen sizes 360px and smaller
@media only screen and (max-width: 359px)
  .hide-on-mobile
    display: none
</style>
