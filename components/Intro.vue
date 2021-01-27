<template>
  <q-card flat bordered class="my-card">
    <q-card-section>
      <div class="text-h6">{{ title }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none">
      What is N3RDefi? N3RDefi is a safe environment, where fellow N3RDz can
      come together to form a community. Being part of a community offers trust,
      strength, safety and commitment to a united cause, this help reduce and
      even eliminate bad actors.
    </q-card-section>
    <q-separator inset />
    <q-card-section>
      Rewards earned for being a good player can be utilised throughout the
      N3RDefi ecosystem, for example to purchase NFT's in our NFT marketplace,
      these can get staked and either put up for sale or used as a blueprint for
      artists, so fellow N3RDs can buy a t-shirt, hoodie or cap with their
      favourite8-Bit Art. Proceeds would be distributed back to NFT holders in
      the form of XP, tokens or various other prizes.
    </q-card-section>
  </q-card>
</template>
<script>
export default {
  name: 'Intro',
  data() {
    return {
      title: 'Welcome to N3RDefi',
    }
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
