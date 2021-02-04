<template>
  <div class="no-margin no-paddig">
    <q-card v-if="user.step === 0" flat bordered class="n3rd-intro n3rd-img-0">
      <q-card-section>
        <div class="n3rd-title">What is a N3RD?</div>
        <div class="n3rd-subtitle">We are all g33ks at heart</div>
        <div class="n3rd-text n3rd-text-one">
          A N3RD is a uniquely generated 8 Bit N3RD character that allows you to
          N3RDefi. There will only be 10,000 first generation N3RDs minted. Ape
          in to your N3RD token today and lets get N3RDy ....
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="left">
        <q-btn
          flat
          color="black"
          label="Let's get N3RDy"
          class="bg-secondary q-mb-sm"
          @click="getN3RDyToken()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 1" flat bordered class="n3rd-intro n3rd-img-1">
      <q-card-section>
        <div class="n3rd-title">N3RDefi is Defi Eco-system</div>
        <div class="n3rd-text n3rd-text-two">
          N3RDefi is a safe environment, where fellow N3RDs can come together to
          form a community. Being part of a community offers trust, strength,
          safety and commitment to a united cause, this help reduce and even
          eliminate bad actors.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="left">
        <q-btn
          flat
          color="white"
          label="Stake N3RDy"
          class="bg-primary q-mb-sm"
          @click="stakeN3RDyToken()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 2" flat bordered class="n3rd-intro n3rd-img-2">
      <q-card-section>
        <div class="n3rd-title">8 Bit Art</div>
        <div class="n3rd-subtitle">NFT Marketplace</div>
        <div class="n3rd-text n3rd-text-three">
          N3RDs love everything 8 Bit and there's nothing<br />better than g33ky
          NFT's. Create your own G33ky<br />NFT's and list them in our 8 Bit NFT
          Marketplace.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="left">
        <q-btn
          flat
          color="black"
          label="Create NFTs"
          class="bg-secondary q-mb-sm"
          @click="createNFT()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 3" flat bordered class="n3rd-intro n3rd-img-3">
      <q-card-section>
        <div class="n3rd-title">SAFU Seal</div>
        <div class="n3rd-subtitle">
          N3RDefi is a safety first Defi Eco-system
        </div>
        <div class="n3rd-text n3rd-text-four">
          N3RDefi is a 8bit D3fi ecosystem, purchase NFT's in our marketplace or
          create your very own 8 bit artwork. All NFT's can be staked for extra
          rewards. Invest in our Smart Vaults for easy yields, we have something
          for you all...
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons justify-end self-end" align="left">
        <q-btn
          flat
          color="white"
          label="Let's get N3RDy"
          class="bg-primary q-mb-sm"
          @click="getN3RDyToken(1000)"
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
        console.log(
          '%c Please check MetaMask and try again!',
          'background: red; color: white'
        )
      }
    },
    async stakeN3RDyToken(amount) {
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log('accountLoaded:', accountLoaded)
        console.log('amount:', amount)
        /* Buy the N3RDy Token */
        const tokens = await this.buyN3RDyTokens(this.user.account, amount)
        console.log('Bought N3RDy Tokens:', tokens)
      } else {
        console.log(
          '%c Please check MetaMask and try again!',
          'background: red; color: white'
        )
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
        console.log(
          '%c Please check MetaMask and try again!',
          'background: red; color: white'
        )
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
    font-size: 22px
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
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-text
    min-height: 130px
    color: $white
    font-family: $button-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
  .n3rd-text-one
    width: 59%
  .n3rd-text-two
    width: 75%
  .n3rd-text-three
    width: 75%
  .n3rd-text-four
    width: 75%
  .n3rd-buttons justify-end self-end
    margin: 0 10px
.n3rd-img-0
  background-image: url('../assets/images/n2d-deviatart.png')
  background-size: cover
  background-repeat: no-repeat
  background-position: center center
  overflow: display
  padding: 0
.n3rd-img-1
  background-image: url('../assets/images/etheruem.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: center top
  overflow: display
  padding: 0
.n3rd-img-2
  background-image: url('../assets/images/forest.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: center center
  overflow: display
  padding: 0
.n3rd-img-3
  background-image: url('../assets/images/3dBG.gif')
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
