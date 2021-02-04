<template>
  <div class="row items-start justify-evenly n3rd-defi">
    <div class="col-3 q-pr-sm">
      <q-card flat bordered class="n3rd-defi-intro n3rd-defi-img">
        <q-card-section>
          <div class="n3rd-defi-title">D3Fi</div>
          <div class="n3rd-defi-text">
            N3RDefi is a safe environment, where fellow N3RDs can come together
            to form a community. Being part of a community offers trust,
            strength, safety and commitment to a united cause, this help reduce
            and even eliminate bad actors.
          </div>
        </q-card-section>
        <q-card-section
          v-if="user.account"
          class="n3rd-defi-buttons justify-end self-end"
          align="right"
        >
          <q-btn
            outline
            color="white"
            label="Go Back"
            class="full-width q-mb-sm q-mr-sm"
            @click="goBack()"
          />
          <q-btn
            flat
            color="black"
            label="Go Home"
            class="full-width bg-secondary q-mb-sm q-mr-sm"
            @click="goHome()"
          />
          <q-btn
            flat
            color="white"
            label="More Info"
            class="full-width bg-primary q-mb-sm"
            @click="nextStep()"
          />
        </q-card-section>
      </q-card>
    </div>
    <div class="col-9 q-pl-sm">
      <div class="nes-table-responsive">
        <pre>{{ aaveTokens }}</pre>
        <table class="nes-table is-bordered is-dark">
          <thead>
            <tr>
              <th>Table.is-dark</th>
              <th>Table.is-bordered</th>
              <th>Table.is-dark</th>
              <th>Table.is-bordered</th>
              <th>Table.is-dark</th>
              <th>Table.is-bordered</th>
              <th>Table.is-dark</th>
              <th>Table.is-bordered</th>
              <th>Table.is-dark</th>
              <th>Table.is-bordered</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
            </tr>
            <tr>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
            </tr>
            <tr>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternon</td>
            </tr>
            <tr>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
              <td>Thou hast had a good morning</td>
              <td>Thou hast had a good afternoon</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* LFG */
export default {
  name: 'G3fi',
  data() {
    return {
      title: 'G3fi',
    }
  },
  computed: {
    ...mapState(['web3', 'user', 'profile', 'aaveTokens']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
      getAaveTokens: 'getAaveTokens',
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
    aaveTokens: {
      get() {
        return this.$store.state.aaveTokens
      },
      set(value) {
        this.$store.commit('SET_AAVE_TOKENS', value)
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
  },
}
</script>
<style lang="sass" scoped>
@import "../assets/sass/theme-variables"

.n3rd-defi
  min-height: 320px
  .n3rd-defi-title
    color: $white
    font-family: $heading-font
    font-size: 22px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: left
  .n3rd-defi-subtitle
    color: $white
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-defi-text
    width: 70%
    color: $white
    font-family: $button-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: left
  .n3rd-defi-buttons
    margin: 0 10px
.n3rd-defi-img
  background-image: url('../assets/images/defi.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: top center
  overflow: display
  padding: 0

.n3rd-market
  min-height: 320px
  .n3rd-market-title
    color: $black
    font-family: $heading-font
    font-size: 18px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 15px 10px
    text-align: left
  .n3rd-market-subtitle
    color: $black
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-market-table
    color: $black
    font-family: $button-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: left
  .n3rd-market-buttons
    margin: 0 10px
.n3rd-img-market
  background-image: url('../assets/images/3dBG.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: top center
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
