<template>
  <q-drawer v-model="leftDrawerOpen" bordered behavior="mobile" class="n3rd-sidebar-left" @click="toggleLeftDrawer(leftDrawerOpen)">
    <q-scroll-area class="fit">
      <q-toolbar class="GPL__toolbar">
        <q-toolbar-title class="row items-center">
          <span class="n3rd-logo q-ml-xs">N3RDefi</span>
        </q-toolbar-title>
      </q-toolbar>
      <q-list padding>
        <q-item v-for="link in links1" :key="link.text" clickable class="GPL__drawer-item">
          <q-item-section avatar>
            <q-icon :name="link.icon" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ link.text }}</q-item-label>
          </q-item-section>
        </q-item>

        <q-separator class="q-my-md" />

        <q-item v-for="link in links2" :key="link.text" clickable class="GPL__drawer-item">
          <q-item-section avatar>
            <q-icon :name="link.icon" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ link.text }}</q-item-label>
          </q-item-section>
        </q-item>

        <q-separator class="q-my-md" />

        <q-item clickable class="GPL__drawer-item GPL__drawer-item--storage">
          <q-item-section avatar>
            <q-icon name="cloud" />
          </q-item-section>
          <q-item-section top>
            <q-item-label>Storage</q-item-label>
            <q-linear-progress :value="storage" class="q-my-sm" />
            <q-item-label caption> 2.6 GB of 15 GB </q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-scroll-area>
  </q-drawer>
</template>
<script>
import { mapGetters } from 'vuex'

export default {
  name: 'SidebarLeft',
  data() {
    return {
      storage: 0.26,
      links1: [
        { icon: 'add', text: 'Create' },
        { icon: 'photo', text: 'Browse' },
        { icon: 'photo_album', text: 'Collections' },
        { icon: 'assistant', text: 'Rankings' },
        { icon: 'book', text: 'Activity' },
        { icon: 'people', text: 'Sharing' },
      ],
      links2: [
        { icon: 'settings', text: 'Settings' },
        { icon: 'help', text: 'Help & Feedback' },
      ],
    }
  },
  computed: {
    ...mapGetters({
      getSearchText: 'searchText',
      getLeftDrawerState: 'leftDrawerOpen',
    }),
    leftDrawerOpen: {
      get() {
        return this.$store.state.leftDrawerOpen
      },
      set(value) {
        this.$store.commit('TOGGLE_LEFTDRAWER', value)
      },
    },
  },
  methods: {
    toggleLeftDrawer(value) {
      this.$store.commit('TOGGLE_LEFTDRAWER', value)
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-sidebar-left
  background-color: $white
  .n3rd-logo
    color: $black
    font-family: $heading-font

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
