<template>
  <q-card class="n3rd-nft-card q-mb-md">
    <q-card-section horizontal>
      {{ nft }}
      <!-- <q-img class="col" src="require('nft.image)" /> -->
      <q-card-actions vertical class="justify-around">
        <q-btn flat round color="red" icon="favorite" />
        <q-btn flat round color="accent" icon="bookmark" />
        <q-btn flat round color="primary" icon="share" />
      </q-card-actions>
    </q-card-section>
    <pre>NFT: {{ nft }}</pre>
  </q-card>
</template>
<script>
export default {
  name: 'ImgCard',
  props: {
    nft: {
      type: Object,
      required: false,
      default: () => {},
    },
  },
}
</script>
<style lang="sass">
@import "../../assets/sass/theme-variables"

.n3rd-nft-card
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
