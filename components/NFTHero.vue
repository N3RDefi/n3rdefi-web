<template>
  <div class="row">
    <div v-for="n in nfts" :key="`sm-${n}`" class="col-4 q-px-sm">
      <ImgCard :nft="n" />
      <pre>NFT: {{ n }}</pre>
    </div>
    <pre>NFTs: {{ nfts }}</pre>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'

import ImgCard from './Cards/ImgCard.vue'

export default {
  name: 'NFTHero',
  components: {
    ImgCard,
  },
  data() {
    return {
      title: 'N3RDy NFT',
      lorem:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    }
  },
  computed: {
    ...mapGetters({
      getNfts: 'getNfts',
    }),
    nfts: {
      get() {
        return this.$store.state.nfts
      },
      set(value) {
        this.$store.commit('GENERATE_NFT', value)
      },
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
