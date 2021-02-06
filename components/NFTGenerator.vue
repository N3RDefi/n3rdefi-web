<template>
  <q-card flat bordered class="n3rd-nft-generator n3rd-img">
    <q-card-section>
      <div class="n3rd-title">{{ title }}</div>
      <div class="n3rd-text">
        Create your own 8 Bit NFT's, stake or farm your digital assets in our digital marketplace to earn rewards from the N3RDS g33k-O-system
      </div>
    </q-card-section>
    <q-card-section>
      <div class="nft-form">
        <q-form ref="nftForm" class="q-gutter-md nftForm" @submit="generateNFT()" @reset="onReset()">
          <q-input
            v-model="name"
            dense
            square
            type="text"
            color="black"
            label-color="black"
            bg-color="white"
            label="Title *"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Please type something!']"
          />
          <q-input
            v-model="price"
            dense
            square
            color="black"
            label-color="black"
            bg-color="white"
            label="Price in Wei"
            mask="#.##"
            fill-mask="0"
            reverse-fill-mask
            hint="ETH: #.##"
            input-class="text-right"
            lazy-rules
            :rules="[
              (val) => (val !== null && val !== '') || 'Please enter your price',
              (val) => (val > 0 && val < 100) || 'Please enter a real value!',
            ]"
          />
          <q-file
            v-model="file"
            dense
            square
            color="black"
            label-color="black"
            bg-color="white"
            label="Pick one file"
            class="q-mb-xl"
            @input="
              (val) => {
                file = val[0]
              }
            "
          />
          <div class="n3rd-buttons" align="center">
            <q-btn flat label="Submit" type="submit" color="white" class="bg-primary full-width q-mb-md" />
            <q-btn flat label="Stake" color="black" class="bg-secondary full-width q-mb-md" />
            <q-btn outline label="Reset" type="reset" color="black" flat class="bg-white full-width q-mb-md" />
          </div>
          <q-toggle
            v-model="accept"
            dense
            checked-icon="check"
            color="green"
            unchecked-icon="clear"
            class="text-white float-center q-pl-sm q-py-sm q-mt-lg"
            label="I accept the licensing Terms &amp; Conditions"
          />
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
      title: '8 Bit NFTs',
      name: null,
      price: 0,
      file: null,
      accept: false,
    }
  },
  methods: {
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
      this.price = 0
      this.file = null
      this.accept = false
    },
    generateNFT(value) {
      const { newNFT } = { ...value }
      this.$store.commit('GENERATE_NFT', newNFT)
    },
  },
}
</script>
<style lang="sass" scope>
@import "../assets/sass/theme-variables"

.n3rd-nft-generator
  background-color: $black
  .nft-form
    max-width: 400px
    margin: 0
    padding: 0
    overflow: hidden
  .nftForm
    max-width: 400px
  .q-file
    max-width: 350px
  .n3rd-title
    color: $white
    font-family: $heading-font
    font-size: 26px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 35px 10px
    text-align: left
  .n3rd-subtitle
    color: $white
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 5px 10px
    text-align: left
  .n3rd-text
    color: $white
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 20px 10px
    text-align: left
  .n3rd-buttons
    max-width: 350px
    margin: 0 -16px 0 16px
.n3rd-img
  background-image: url('../assets/images/animated-moon.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: bottom left
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
