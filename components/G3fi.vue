<template>
  <div class="row items-center justify-evenly">
    <div class="col q-pr-sm">
      <q-card flat bordered class="my-card">
        <q-card-section>
          <div class="text-h6">{{ title }}</div>
        </q-card-section>
        <q-card-section class="q-pt-none">
          {{ lorem }}
        </q-card-section>
        <q-separator inset />
        <q-card-section>
          {{ lorem }}
        </q-card-section>
      </q-card>
    </div>
    <div class="col q-pl-sm">
      <q-card flat bordered class="my-card">
        <q-card-section>
          <div class="text-h6">{{ title }}</div>
        </q-card-section>
        <q-card-section class="q-pt-none">
          {{ lorem }}
        </q-card-section>
        <q-separator inset />
        <q-card-section>
          {{ lorem }}
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>
<script>
export default {
  name: 'G3fi',
  data() {
    return {
      title: 'G3fi',
      lorem:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
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
