<template>
  <q-card flat bordered class="n3rd-seal n3rd-seal-img">
    <q-card-section>
      <div class="n3rd-seal-title">SAFU Seal</div>
      <div class="n3rd-seal-subtitle">
        N3RDefi is a safety first Defi Eco-system
      </div>
      <div class="n3rd-seal-text">
        N3RDefi offers a full range of Defi solutions including Aave borrow,
        lend and staking with aTokens. Our deflationary models mean up only,
        really is up only! Our top priority is that funds are SAFU.
      </div>
    </q-card-section>
    <q-card-section class="n3rd-seal-buttons justify-end self-end" align="left">
      <q-btn
        outline
        color="black"
        label="SAFU Seal"
        class="bg-orange q-mb-sm"
        @click="getSafuSealToken()"
      />
    </q-card-section>
  </q-card>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* LFG */
export default {
  name: 'Seal',
  data() {
    return {
      title: 'SAFU Seal',
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
    async getSafuSealToken(amount) {
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
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-seal
  min-height: 400px
  .n3rd-seal-title
    color: $orange
    font-family: $heading-font
    font-size: 26px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 25px 10px
    text-align: left
  .n3rd-seal-subtitle
    color: $white
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-seal-text
    min-height: 130px
    color: $white
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    width: 75%
  .n3rd-seal-buttons
    margin: 0 10px
.n3rd-seal-img
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
