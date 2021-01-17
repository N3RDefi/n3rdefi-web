<template>
  <q-header elevated class="n3rd-header" height-hint="64">
    <q-toolbar class="GPL__toolbar" style="height: 64px">
      <q-btn
        v-if="$q.screen.lt.md"
        flat
        dense
        round
        aria-label="Menu"
        icon="menu"
        class="q-mx-sm"
        color="black"
        @click="toggleLeftDrawer(leftDrawerOpen)"
      />
      <q-toolbar-title shrink class="row items-center no-wrap">
        <span class="n3rd-logo q-mt-xs">N3RDefi</span>
      </q-toolbar-title>
      <q-space />
      <q-input
        v-model="searchText"
        class="GPL__toolbar-input"
        dense
        standout="bg-primary"
        placeholder="Search"
      >
        <template #prepend>
          <q-icon v-if="searchText === ''" name="search" />
        </template>
        <template #append>
          <q-icon
            v-if="searchText !== ''"
            name="clear"
            class="cursor-pointer"
            @click="search('')"
          />
        </template>
      </q-input>
      <q-space />
      <div class="q-gutter-sm row items-center no-wrap">
        <q-btn round dense flat color="grey-8" icon="notifications">
          <q-badge
            v-if="notifications !== 0"
            color="red"
            text-color="white"
            floating
            >{{ notifications }}</q-badge
          >
        </q-btn>

        <q-btn round flat>
          <q-avatar size="30px">
            <img src="https://cdn.quasar.dev/img/boy-avatar.png" />
          </q-avatar>
          <q-menu anchor="top end" self="bottom left">
            <q-list class="text-grey-8">
              <q-item
                v-for="menu in userMenu"
                :key="menu.text"
                v-close-popup
                clickable
                aria-hidden="true"
              >
                <!-- <q-item-section avatar>
                  <q-icon :name="menu.icon" />
                </q-item-section> -->
                <q-item-section>{{ menu.text }}</q-item-section>
              </q-item>
            </q-list>
          </q-menu>
        </q-btn>
      </div>
    </q-toolbar>
  </q-header>
</template>
<script>
import { mapMutations, mapGetters } from 'vuex'

export default {
  name: 'Header',
  data() {
    return {
      notifications: 0,
      userMenu: [
        { icon: 'photo', text: 'My N3RDs' },
        { icon: 'photo_album', text: 'Activity' },
        { icon: 'people', text: 'Offers Received' },
        { icon: 'movie', text: 'Offers Sent' },
      ],
    }
  },
  computed: {
    ...mapGetters({
      getSearchText: 'searchText',
      getLeftDrawerState: 'leftDrawerOpen',
    }),
    searchText: {
      get() {
        return this.$store.state.searchText
      },
      set(value) {
        this.$store.commit('SEARCH', value)
      },
    },
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
    search(value) {
      this.$store.commit('SEARCH', value)
    },
    toggleLeftDrawer(value) {
      this.$store.commit('TOGGLE_LEFTDRAWER', value)
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-header
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
