<template>
  <q-card flat bordered class="my-card">
    <q-card-section>
      <div class="text-h6">{{ title }}</div>
    </q-card-section>
    <q-card-section class="q-pt-none"
      >Connect your account to continue ....</q-card-section
    >
    <q-card-section class="q-pt-none">
      <pre>{{ user }}</pre>
    </q-card-section>
    <q-card-section>
      <q-btn
        v-if="!user"
        outline
        color="grey-8"
        class="full-width"
        @click="connectUser()"
        >Connect</q-btn
      >
    </q-card-section>
  </q-card>
</template>
<script>
import { mapMutations, mapGetters } from 'vuex'

export default {
  name: 'Connect',
  data() {
    return {
      title: 'Account',
    }
  },
  computed: {
    ...mapGetters({
      getUser: 'getUser',
    }),
    user: {
      get() {
        return this.$store.state.user
      },
      set(value) {
        this.$store.commit('SEARCH', value)
      },
    },
  },
  methods: {
    connectUser(value) {
      this.$store.commit('CONNECT_USER', value)
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
