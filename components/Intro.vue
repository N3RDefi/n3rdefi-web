<template>
  <q-card flat bordered class="n3rd-intro n3rd-img">
    <q-card-section>
      <div class="n3rd-title">Welcome to N3RDefi?</div>
      <div class="n3rd-subtitle">An eco-system for all N3RDs</div>
      <div class="n3rd-text">
        Come join us as we apein to decentralized finance (Defi)<br />Create
        your very own NFT's and farm your 8 bit artwork<br />Learn more about
        D3fi and blockchain development
      </div>
    </q-card-section>
    <q-card-section v-if="user.web3Instance" class="n3rd-buttons" align="right">
      <q-btn
        v-if="user.step >= 0 && user.step <= 2"
        outline
        color="black"
        label="Go Back"
        class="q-mb-sm q-mr-sm"
        @click="goBack()"
      />
      <q-btn
        v-if="user.step === 3"
        flat
        color="black"
        label="Go Home"
        class="bg-secondary q-mb-sm q-mr-sm"
        @click="goHome()"
      />
      <q-btn
        v-if="user.step >= 0 && user.step <= 3"
        flat
        color="white"
        label="More Info"
        class="bg-primary q-mb-sm"
        @click="nextStep()"
      />
    </q-card-section>
  </q-card>
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
    nextStep() {
      if (this.user.step === 3) {
        $nuxt.$store.dispatch('setStep', 0)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step + 1)
      }
    },
    goBack() {
      if (this.user.step === 0) {
        $nuxt.$store.dispatch('setStep', 3)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step - 1)
      }
    },
    goHome() {
      $nuxt.$store.dispatch('setStep', 1)
    },
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
    color: $black
    font-family: $heading-font
    font-size: 22px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: right
  .n3rd-subtitle
    color: $black
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: right
  .n3rd-text
    color: $black
    font-family: $button-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: right
  .n3rd-buttons
    margin: 0 10px 0 0
.n3rd-img
  background-image: url('../assets/images/SuperN3RD.png')
  background-size: 48%
  background-repeat: no-repeat
  background-position: -65px 25px
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
