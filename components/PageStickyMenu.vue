<template>
  <q-page-sticky v-if="$q.screen.gt.sm" expand position="left" class="n3rd-page-sticky-sidebar">
    <div class="fit q-pt-xl q-px-sm column">
      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="add" />
        <div class="GPL__side-btn__label">N3RDs</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="photo" />
        <div class="GPL__side-btn__label">D3Fi</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="photo" />
        <div class="GPL__side-btn__label">Swap</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="photo" />
        <div class="GPL__side-btn__label">Pools</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="photo_album" />
        <div class="GPL__side-btn__label">NFT's</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="assistant" />
        <div class="GPL__side-btn__label">Marketplace</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="book" />
        <div class="GPL__side-btn__label">Account</div>
      </q-btn>

      <q-btn round flat color="white" stack no-caps size="26px" class="GPL__side-btn">
        <q-icon size="22px" name="people" />
        <div class="GPL__side-btn__label">Sharing</div>
      </q-btn>
    </div>
  </q-page-sticky>
</template>
<script>
export default {
  name: 'Header',
  data() {
    return {}
  },
}
</script>
<style lang="sass" scope>
@import "../assets/sass/theme-variables"

.n3rd-page-sticky-sidebar
  background-color: $charcoal
  border: 4px solid $primary
  /* top | right | bottom | left */
  border-style: none inset outset none

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
