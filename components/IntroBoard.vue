<template>
  <div class="no-margin no-paddig">
    <q-card v-if="user.step === 0" flat bordered class="n3rd-intro n3rd-img-0">
      <q-card-section>
        <div class="n3rd-title">Let's get N3RDy...</div>
        <div class="n3rd-subtitle">We are all g33ks at heart</div>
        <div class="n3rd-text n3rd-text-one">
          A N3RD is a uniquely generated 8 Bit N3RD character that allows you to N3RDefi. There will only be 10,000 first generation N3RDs minted. Ape
          in to your N3RD token today and lets get N3RDy ....
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="center">
        <q-btn
          outline
          color="black"
          label="Let's get N3RDy"
          class="bg-secondary q-mb-sm"
          :icon="`img:${require('@/assets/icons/precision_manufacturing.svg') ? require('@/assets/icons/precision_manufacturing.svg') : ''}`"
          @click="getN3RDyToken()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 1" flat bordered class="n3rd-intro n3rd-img-2">
      <q-card-section>
        <div class="n3rd-title">8 Bit Art</div>
        <div class="n3rd-subtitle">NFT Marketplace</div>
        <div class="n3rd-text n3rd-text-two">
          N3RDs love everything 8 Bit and there's nothing better than g33ky NFT's. Create your own G33ky NFT's and list them in our 8 Bit NFT
          Marketplace.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="center">
        <q-btn
          outline
          color="black"
          label="Create NFTs"
          class="bg-secondary q-mb-sm"
          :icon="`img:${require('@/assets/icons/stars.svg') ? require('@/assets/icons/stars.svg') : ''}`"
          @click="createNFT()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 2" flat bordered class="n3rd-intro n3rd-img-1">
      <q-card-section>
        <div class="n3rd-title-orange">SAFU Vaults</div>
        <div class="n3rd-subtitle">D3Fi means funds are SAFU</div>
        <div class="n3rd-text n3rd-text-three">
          N3RDefi offers a full range of Defi solutions including Aave borrow, lend and staking with aTokens. Our deflationary models mean up only,
          really is up only! Our top priority is that funds are SAFU.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="left">
        <q-btn
          outline
          color="black"
          label="SAFU Protocol"
          class="bg-orange q-mb-sm"
          :icon="`img:${require('@/assets/icons/speed.svg') ? require('@/assets/icons/speed.svg') : ''}`"
          @click="safuProtocol()"
        />
      </q-card-section>
    </q-card>
  </div>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* LFG */
export default {
  name: 'IntroBoards',
  data() {
    return {
      title: 'N3rds',
    }
  },
  computed: {
    ...mapState(['web3', 'user', 'profile']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
    }),
    web3: {
      get() {
        return this.$store.state.web3
      },
      set(value) {
        this.$store.commit('SET_WEB3', value)
      },
    },
    user: {
      get() {
        return this.$store.state.user
      },
      set(value) {
        this.$store.commit('SET_USER', value)
      },
    },
    profile: {
      get() {
        return this.$store.state.profile
      },
      set(value) {
        this.$store.commit('SET_PROFILE', value)
      },
    },
  },
  methods: {
    async getN3RDyToken(amount) {
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log('accountLoaded:', accountLoaded)
        console.log('amount:', amount)
        /* Buy the N3RDy Token */
        const tokens = await this.buyN3RDyTokens(this.user.account, amount)
        console.log('Bought N3RDy Tokens:', tokens)
      } else {
        console.log('%c Please check MetaMask and try again!', 'background: red; color: white')
      }
    },
    async safuProtocol(amount) {
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log('accountLoaded:', accountLoaded)
        console.log('amount:', amount)
        /* Buy the N3RDy Token */
        const tokens = await this.buyN3RDyTokens(this.user.account, amount)
        console.log('Bought N3RDy Tokens:', tokens)
      } else {
        console.log('%c Please check MetaMask and try again!', 'background: red; color: white')
      }
    },
    async createNFT(amount) {
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log('accountLoaded:', accountLoaded)
        console.log('amount:', amount)
        /* Buy the N3RDy Token */
        const tokens = await this.buyN3RDyTokens(this.user.account, amount)
        console.log('Bought N3RDy Tokens:', tokens)
      } else {
        console.log('%c Please check MetaMask and try again!', 'background: red; color: white')
      }
    },
  },
}
</script>
<style lang="sass" scope>
@import "./../assets/sass/theme-variables"

.n3rd-intro
  min-height: 380px
  .n3rd-title
    color: $white
    font-family: $heading-font
    font-size: 24px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: left
  .n3rd-title-orange
    color: $orange
    font-family: $heading-font
    font-size: 24px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: left
  .n3rd-subtitle
    color: $white
    font-family: $heading-font
    font-size: 14px
    line-height: 22px
    font-weight: 400
    letter-spacing 0.10px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-text
    min-height: 130px
    color: $white
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
  .n3rd-text-one
    width: 60%
  .n3rd-text-two
    width: 75%
  .n3rd-text-three
    width: 70%
  .n3rd-buttons
    margin: 0 10px 0 0
.n3rd-img-0
  background-image: url('../assets/images/n2d-deviatart.png')
  background-size: cover
  background-repeat: no-repeat
  background-position: center center
  overflow: display
  padding: 0
.n3rd-img-1
  background-image: url('../assets/images/AAVE.png'), url('../assets/images/star-background-full-bg.jpg')
  background-size: 180px, cover
  background-repeat: no-repeat, no-repeat
  background-position: bottom right, center top
  overflow: display
  padding: 0
.n3rd-img-2
  background-image: url('../assets/images/forest.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: center center
  overflow: display
  padding: 0

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
