<template>
  <q-card flat bordered class="n3rd-card n3rd-account-card">
    <q-card-section>
      <div class="text-h6">{{ title }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>Web3 Instance: {{ web3.web3Instance }}</p>
      <p>Is MetaMask: {{ web3.isMetaMask }}</p>
      <p>Chain Id HEX: {{ web3.chainIdHEX }}</p>
      <p>Network: {{ networkFilter(web3.chainIdHEX) }}</p>
      <p>Account: {{ web3.account[0] }}</p>
      <p>Balance: {{ web3.balance }}</p>
    </q-card-section>
    <!-- <q-card-section>
      <q-btn
        v-if="!user"
        outline
        color="grey-8"
        class="full-width"
        @click="connectUser()"
        >Connect</q-btn
      >
    </q-card-section> -->
    <q-card-section class="q-pt-none">
      <pre>WEB3: {{ web3 }}</pre>
    </q-card-section>
  </q-card>
</template>
<script>
import { networkFilter } from '~/util/networkFilter'
export default {
  name: 'Account',
  props: {
    web3: {
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
    networkFilter(chainId) {
      return networkFilter(chainId)
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
