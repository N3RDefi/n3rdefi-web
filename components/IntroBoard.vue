<template>
  <div class="no-margin no-paddig">
    <q-card v-if="user.step === 0" flat bordered class="n3rd-intro n3rd-img-0">
      <q-card-section>
        <div class="n3rd-title">What is a N3RD?</div>
        <div class="n3rd-subtitle">We are all g33ks at heart</div>
        <div class="n3rd-text">
          A N3RD is a uniquely generated 8 Bit N3RD character that allows you to
          N3RDefi. There will only be 10,000 first generation N3RDs minted. Ape
          in to your N3RD token today and lets get N3RDy ....
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons" align="left">
        <q-btn
          flat
          color="white"
          label="Press Start"
          class="text-black bg-secondary"
          @click="mintN3RD()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 1" flat bordered class="n3rd-intro n3rd-img-1">
      <q-card-section>
        <div class="n3rd-title">8 Bit Art</div>
        <div class="n3rd-subtitle">NFT Marketplace and 8 bit art board</div>
        <div class="n3rd-text">
          N3RDs love everything 8 Bit and there's nothing<br />better than g33ky
          NFT's. Create your own G33ky<br />NFT's and list them in our 8 Bit NFT
          Marketplace.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons" align="left">
        <q-btn
          flat
          color="white"
          label="Press Start"
          class="text-black bg-secondary"
          @click="mintN3RD()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 2" flat bordered class="n3rd-intro n3rd-img-2">
      <q-card-section>
        <div class="n3rd-title">What is D3fi?</div>
        <div class="n3rd-subtitle">N3RDefi is Defi eco-system</div>
        <div class="n3rd-text">
          N3RDefi is a safe environment, where fellow N3RDs can come together to
          form a community. Being part of a community offers trust, strength,
          safety and commitment to a united cause, this help reduce and even
          eliminate bad actors.
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons" align="left">
        <q-btn
          flat
          color="white"
          label="Press Start"
          class="text-black bg-secondary"
          @click="mintN3RD()"
        />
      </q-card-section>
    </q-card>
    <q-card v-if="user.step === 3" flat bordered class="n3rd-intro n3rd-img-3">
      <q-card-section>
        <div class="n3rd-title">SAFU Seal</div>
        <div class="n3rd-subtitle">
          N3RDefi is a safety first Defi Eco-system
        </div>
        <div class="n3rd-text">
          N3RDefi is a 8bit D3fi ecosystem, purchase NFT's in our marketplace or
          create your very own 8 bit artwork. All NFT's can be staked for extra
          rewards. Invest in our Smart Vaults for easy yields, we have something
          for you all...
        </div>
      </q-card-section>
      <q-card-section class="n3rd-buttons" align="left">
        <q-btn
          flat
          color="white"
          label="Press Start"
          class="text-black bg-secondary"
          @click="mintN3RD()"
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
  name: 'Intro',
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
    async mintN3RD() {
      /* Load User Account Info into the store */
      // const accountLoaded = await this.loadAccount()
      // if (accountLoaded) {
      //   console.log('accountLoaded:', accountLoaded)
      //   /* Mint the N3RD Token */
      //   const mintedN3RD = await this.mintN3RD()
      //   console.log('mintedN3RD:', mintedN3RD)
      // } else {
      //   console.log(
      //     '%c Please connect MetaMask!',
      //     'background: red; color: white'
      //   )
      // }
    },
  },
}
</script>
<style lang="sass" scoped>
@import "./../assets/sass/theme-variables"

.n3rd-intro
  min-height: 320px
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
    color: $white
    font-family: $button-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: left
  .n3rd-buttons
    margin: 0 10px
.n3rd-img-0
  background-image: url('../assets/images/3dBG.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: top center
  overflow: display
  padding: 0
.n3rd-img-1
  background-image: url('../assets/images/n2d-deviatart.png')
  background-size: cover
  background-repeat: no-repeat
  background-position: center top
  overflow: display
  padding: 0
.n3rd-img-2
  background-image: url('../assets/images/etheruem.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: center center
  overflow: display
  padding: 0
.n3rd-img-3
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
