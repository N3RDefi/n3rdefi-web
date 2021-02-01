<template>
  <q-card flat bordered class="n3rd-nft-generator n3rd-img">
    <q-card-section>
      <div class="n3rd-title">{{ title }}</div>
      <div class="n3rd-subtitle">Create your very own 8 Bit Art</div>
      <div class="n3rd-text">
        Create your very own 8 bit NFT, these can get staked and either put up
        for sale or used as a blueprint for artists, so fellow N3RDs can buy
        t-shirs, hoodie or cap with their favourite 8-Bit Art. Proceeds would be
        distributed back to NFT holders in the form of XP, tokens or various
        other prizes.
      </div>
    </q-card-section>
    <q-card-section class="n3rd-buttons" align="left">
      <q-btn
        flat
        color="white"
        label="Press Start"
        class="text-black bg-secondary"
        @click="toggleForm()"
      />
    </q-card-section>
    <q-card-section v-if="showForm">
      <div class="q-pa-md" style="max-width: 400px">
        <q-form
          ref="nftForm"
          class="q-gutter-md"
          @submit="generateNFT"
          @reset="onReset"
        >
          <q-input
            v-model="name"
            filled
            label="Name *"
            hint="NFT name"
            lazy-rules
            :rules="[
              (val) => (val && val.length > 0) || 'Please type something',
            ]"
          />

          <q-input
            v-model="age"
            filled
            type="number"
            label="Your age *"
            lazy-rules
            :rules="[
              (val) => (val !== null && val !== '') || 'Please type your age',
              (val) => (val > 0 && val < 100) || 'Please type a real age',
            ]"
          />
          <q-toggle v-model="accept" label="I accept the license and terms" />

          <div>
            <q-btn
              outline
              label="Submit"
              type="submit"
              color="primary"
              class="full-width q-mb-sm"
            />
            <q-btn
              label="Reset"
              type="reset"
              color="primary"
              flat
              class="full-width"
            />
          </div>
        </q-form>
      </div>
    </q-card-section>
  </q-card>
</template>
<script>
export default {
  name: 'NFTGenerator',
  data() {
    return {
      title: 'Create your 8-Bit NFT',
      showForm: false,
      name: null,
      age: null,
      accept: false,
    }
  },
  methods: {
    toggleForm() {
      this.showForm = !this.showForm
    },
    onSubmit() {
      if (this.accept !== true) {
        this.$q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'warning',
          message: 'You need to accept the license and terms first',
        })
      } else {
        this.$q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'cloud_done',
          message: 'Submitted',
        })
      }
    },

    onReset() {
      this.name = null
      this.age = null
      this.accept = false
    },

    generateNFT(value) {
      const { newNFT } = { ...value }
      this.$store.commit('GENERATE_NFT', newNFT)
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-nft-generator
  background-color: $black
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
.n3rd-img
  background-image: url('../assets/images/8-bit-moon-tall-bg.jpg')
  background-size: 100%
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
