<template>
  <q-card flat bordered class="n3rd-intro n3rd-img">
    <q-card-section>
      <div class="n3rd-intro-title float-right">Welcome to N3RDefi</div>
      <div class="n3rd-intro-subtitle float-right">An eco-system for all things N3rdy</div>
      <div class="n3rd-intro-text float-right" align="right">
        Come join us as we ape in to 8 bit NFT art and gamefi Defi. Get your very own N3RD Diamond NFT, but hurry, there's only 10 000 of these unique
        <strong>1st Gen. N3RD NFT's</strong>, step aside cryptopunks, lock your kitties away because the N3rds are coming!
      </div>
    </q-card-section>
    <q-card-section v-if="user.web3Instance" class="n3rd-intro-buttons float-right items-center justify-end self-end" align="right">
      <q-btn outline color="black" label="Go Back" class="q-mb-sm q-ml-sm" icon="fast_rewind" @click="goBack()" />
      <q-btn
        v-if="user.step >= 0 && user.step <= 2"
        outline
        color="white"
        :label="user.step === 0 ? 'Play' : 'GameFi'"
        :class="user.step === 0 ? 'play-button bg-primary q-mb-sm' : 'play-button text-black bg-secondary q-mb-sm'"
        :icon-right="user.step === 0 ? 'play_arrow' : 'gamepad'"
        class="bg-primary"
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
      if (this.user.step === 2) {
        $nuxt.$store.dispatch('setStep', 0)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step + 1)
      }
    },
    goBack() {
      if (this.user.step === 0) {
        $nuxt.$store.dispatch('setStep', 2)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step - 1)
      }
    },
  },
}
</script>
<style lang="sass" scoped>
@import "./../assets/sass/theme-variables"

.n3rd-intro
  min-height: 380px
  .n3rd-intro-title
    color: $black
    font-family: $heading-font
    font-size: 24px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: right
  .n3rd-intro-subtitle
    color: $black
    font-family: $heading-font
    font-size: 14px
    line-height: 22px
    font-weight: 400
    letter-spacing 0.10px
    margin: 0 10px 25px 10px
    text-align: right
  .n3rd-intro-text
    width: 66%
    min-height: 130px
    color: $black
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: right
  .n3rd-intro-buttons
    margin: 0 10px 0 0
  .play-button
    min-width: 120px
.n3rd-img
  background-image: url('../assets/images/SuperN3RD.png')
  background-size: contain
  background-repeat: no-repeat
  background-position: -65px 35px
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
