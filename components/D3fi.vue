<template>
  <q-card flat bordered class="n3rd-d3fi n3rd-d3fi-img">
    <q-card-section>
      <div class="n3rd-d3fi-title">A D3fi Eco-system</div>
      <div class="n3rd-d3fi-text">
        N3RDefi is a safe environment, where fellow N3RDs can come together to
        form a community. Being part of a community offers trust, strength,
        safety and commitment to a united cause, this help reduce and even
        eliminate bad actors.
      </div>
    </q-card-section>
    <q-card-section class="n3rd-d3fi-buttons justify-end self-end" align="left">
      <q-btn
        outline
        color="white"
        label="Stake N3RDy"
        class="bg-primary q-mb-sm"
        @click="stakeN3RDyToken()"
      />
    </q-card-section>
  </q-card>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* LFG */
export default {
  name: 'D3Fi',
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
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-d3fi
  min-height: 400px
  .n3rd-d3fi-title
    color: $white
    font-family: $heading-font
    font-size: 22px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: left
  .n3rd-d3fi-subtitle
    color: $white
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-d3fi-text
    min-height: 130px
    color: $white
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    width: 59%
  .n3rd-d3fi-buttons justify-end self-end
    margin: 0 10px
.n3rd-d3fi-img
  background-image: url('../assets/images/etheruem.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: center top
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
