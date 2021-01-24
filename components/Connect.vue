<template>
  <q-card flat bordered class="n3rd-card n3rd-connect-card">
    <q-card-section>
      <div class="text-h6">{{ title }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none"
      >{{ !user.web3Instance ? 'Install Metamask' : 'Connect' }} your MetaMask
      to continue ....</q-card-section
    >
    <q-card-section>
      <q-btn
        outline
        :color="!user.web3Instance ? 'primary' : 'grey-8'"
        :label="!user.web3Instance ? 'Install' : 'Connect'"
        class="full-width"
        @click="connectMetaMask()"
      />
    </q-card-section>
  </q-card>
</template>
<script>
/* Enums and Helper */
import { networks } from '~/util/networks'
import { networkFilter } from '~/util/networkFilter'
/* LFG */
export default {
  name: 'Connect',
  props: {
    user: {
      type: Object,
      required: false,
      default: () => ({}),
    },
  },
  data() {
    return {
      title: 'Connect',
    }
  },
  methods: {
    async connectMetaMask() {
      /* Check Web3 Instance */
      const web3_ = await this.$web3()
      this.$store.commit('SET_WEB3', web3_)
      /* Enable MetaMask and Sign in */
      if (web3_ && web3_.isMetaMask === true) {
        this.$store.commit('SET_IS_METAMASK', true)
      }
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log(
          '%c MetaMask connected successfully!',
          'background: blue; color: white'
        )
      } else {
        console.log(
          '%c Please connect MetaMask!',
          'background: red; color: white'
        )
      }
    },
    async loadAccount() {
      /* Load Network, Account and Balance/s */
      const account = await this.$web3.connectMetaMask()
      if (account && account !== '') {
        this.$store.commit('SET_ACCOUNT', account)
        const chainIdHEX = await this.$web3.getChainId(account)
        this.$store.commit('SET_CHAIN_ID_HEX', chainIdHEX)
        const chainName = networkFilter(chainIdHEX)
        this.$store.commit('SET_CHAIN_NAME', chainName)
        const balance = await this.$web3.getBalance(account)
        this.$store.commit('SET_BALANCE', balance)
        return true
      } else {
        return false
      }
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-card
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
