<template>
  <q-card flat bordered class="my-card">
    <q-card-section>
      <div class="text-h6">{{ title }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none"></q-card-section>
    <q-card-section>
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
import { mapMutations, mapGetters } from 'vuex'

export default {
  name: 'NFTGenerator',
  data() {
    return {
      title: 'Create your 8-Bit NFT',
      name: null,
      age: null,
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

.n3rd-element
  background-color: $white

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
