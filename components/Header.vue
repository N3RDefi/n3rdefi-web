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
        dark
        dense
        square
        color="black"
        standout="bg-white"
        bg-color="black"
        class="GPL__toolbar-input"
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
        <q-btn
          v-if="!profile.isAuthenticated"
          dense
          outline
          :color="!user.account ? 'white' : 'white'"
          :label="!user.account ? 'Connect' : 'Load Arkane'"
          :class="
            !user.account
              ? 'arkane-button bg-primary'
              : 'arkane-button text-black bg-secondary'
          "
          :icon="!user.account ? 'play_arrow' : 'gamepad'"
          @click="!user.account ? connectMetaMask() : connectArkane()"
        />
        <q-btn v-if="!profile.firstName && !profile.email" round flat>
          <q-avatar size="36px">
            <img src="https://cdn.quasar.dev/img/chaosmonkey.png" />
          </q-avatar>
        </q-btn>
        <!-- User Account Dropdown Button -->
        <q-btn
          v-if="user.account && profile.firstName && profile.email"
          round
          flat
        >
          <q-avatar size="36px">
            <img src="../assets/images/N3RD.png" width="36px" />
          </q-avatar>
          <q-menu anchor="top end" self="bottom left">
            <q-list class="text-grey-8">
              <q-item class="computer-font">
                <q-item-section
                  ><strong
                    >Account:
                    {{ profile.firstName + ' ' + profile.lastName }}</strong
                  ></q-item-section
                >
              </q-item>
              <!-- <q-item class="computer-font">
                <q-item-section> {{ profile.username }}</q-item-section>
              </q-item>
              <q-item class="computer-font">
                <q-item-section> {{ profile.email }}</q-item-section>
              </q-item> -->
              <q-item class="computer-font">
                <q-item-section> {{ user.account[0] }}</q-item-section>
              </q-item>
              <q-item class="computer-font">
                <q-item-section avatar>
                  <q-icon name="money" />
                </q-item-section>
                <q-item-section>{{ user.balance }}</q-item-section>
              </q-item>
            </q-list>
          </q-menu>
        </q-btn>
        <!-- END User Account Dropdown Button -->
        <!-- Network Button -->
        <q-btn
          v-if="user.chainIdHEX"
          round
          dense
          flat
          :color="networkColor"
          :icon="networkIcon"
        >
          <q-tooltip :content-class="`bg-${networkColor}`">{{
            user.chainName
          }}</q-tooltip>
        </q-btn>
        <!-- END Network Button -->
      </div>
    </q-toolbar>
  </q-header>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* Arkane Connect for Wallet */
import { ArkaneConnect } from '../node_modules/@arkane-network/arkane-connect'
/* Enums and Helper */
// import { networks } from './networks'
import { networkFilter } from '../util/networkFilter'
import { networkColor } from '../util/networkColor'
/* LFG */
export default {
  name: 'Header',
  data() {
    return {
      network: null,
    }
  },
  computed: {
    ...mapState(['web3', 'user', 'profile', 'searchText', 'leftDrawerOpen']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
      getSearchText: 'searchText',
      getLeftDrawerState: 'leftDrawerOpen',
    }),
    web3: {
      get() {
        return this.$store.state.web3
      },
      set(value) {
        this.$store.commit('SET_WEB3', value)
      },
    },
    user: {
      get() {
        return this.$store.state.user
      },
      set(value) {
        this.$store.commit('SET_USER', value)
      },
    },
    profile: {
      get() {
        return this.$store.state.profile
      },
      set(value) {
        this.$store.commit('SET_PROFILE', value)
      },
    },
    searchText: {
      get() {
        return this.$store.state.searchText
      },
      set(value) {
        this.$store.commit('SET_SEARCH', value)
      },
    },
    networkColor() {
      return networkColor(this.$store.state.user.chainIdHEX, 'color')
    },
    networkIcon() {
      return networkColor(this.$store.state.user.chainIdHEX, 'icon')
    },
  },
  async beforeCreate() {
    /* Check ArkaneProvider Instance */
    const arkaneProvider = await this.$web3.connectArkaneProvider()
    if (arkaneProvider) {
      console.log(
        '%c ArkaneProvider loaded successfully!',
        'background: blue; color: white'
      )
    } else {
      console.log(
        '%c Please connect arkaneProvider!',
        'background: red; color: white'
      )
    }
  },
  methods: {
    search(value) {
      this.$store.commit('SEARCH', value)
    },
    toggleLeftDrawer(value) {
      this.$store.commit('TOGGLE_LEFTDRAWER', value)
    },
    networkFilter(chainId, filterType) {
      return networkFilter(chainId, filterType)
    },
    async connectMetaMask() {
      /* Check Web3 Instance */
      const web3 = await this.$web3()
      this.$store.commit('SET_WEB3', web3)
      /* Enable MetaMask and Sign in */
      if (web3 && web3.isMetaMask === true) {
        this.$store.commit('SET_IS_METAMASK', true)
      }
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log(
          '%c MetaMask connected successfully!',
          'background: blue; color: white'
        )
      } else {
        console.log(
          '%c Please connect MetaMask!',
          'background: red; color: white'
        )
      }
    },
    async loadAccount() {
      /* Load Network, Account and Balance/s */
      const account = await this.$web3.connectMetaMask()
      if (account && account !== '') {
        this.$store.commit('SET_ACCOUNT', account)
        const chainIdHEX = await this.$web3.getChainId(account)
        this.$store.commit('SET_CHAIN_ID_HEX', chainIdHEX)
        const chainId = networkFilter(chainIdHEX, 'id')
        this.$store.commit('SET_CHAIN_ID', chainId)
        const chainName = networkFilter(chainIdHEX, 'name')
        this.$store.commit('SET_CHAIN_NAME', chainName)
        const balance = await this.$web3.getBalance(account)
        this.$store.commit('SET_BALANCE', balance)
        return true
      }
      return false
    },
    async connectArkane() {
      try {
        if (
          process.env.NODE_ENV === 'development' ||
          process.env.NODE_ENV === 'staging'
        ) {
          /* Use staging environment on ArkaneConnect */
          const arkaneConnect = new ArkaneConnect(process.env.APP_NAME, {
            environment: 'staging',
          })
          const authArkaneAccount = await this.authArkaneAccount(arkaneConnect)
          console.log('authArkaneAccount:', authArkaneAccount)
          if (authArkaneAccount.isAuthenticated) {
            this.$store.commit('SET_PROFILE_ISAUTHENTICATED', true)
            const arkaneProfile = await this.getArkaneProfile(arkaneConnect)
            console.log('arkaneProfile:', arkaneProfile)
            this.$store.commit('SET_PROFILE', arkaneProfile)
          }
        } else {
          /* Use Mainnet environment on ArkaneConnect */
          const arkaneConnect = new ArkaneConnect(process.env.APP_NAME)
          const authArkaneAccount = await this.authArkaneAccount(arkaneConnect)
          console.log('authArkaneAccount:', authArkaneAccount)
          if (authArkaneAccount.isAuthenticated) {
            this.$store.commit('SET_PROFILE_ISAUTHENTICATED', true)
            const arkaneProfile = await this.getArkaneProfile(arkaneConnect)
            console.log('arkaneProfile:', arkaneProfile)
            this.$store.commit('SET_PROFILE', arkaneProfile)
          }
        }
      } catch (error) {
        // Handle the error
        console.error(error)
      }
    },
    async authArkaneAccount(arkaneConnect) {
      /* Check if a user is authenticated with Arkane */
      const authenticationInstance = await arkaneConnect
        .checkAuthenticated()
        .then((result) =>
          result
            .authenticated((auth) => {
              console.log(`The user is authenticated: ${auth.subject}`)
            })
            .notAuthenticated((auth) => {
              console.log(`The user is NOT authenticated: ${auth}`)
            })
        )
      // AuthenticationInstance - see https://docs.arkane.network/widget/widget-advanced/object-type-reference/authenticationinstance
      // {
      //   authenticated?: boolean;
      //   subject?: string;
      //   realmAccess?: { roles: string[] };
      //   resourceAccess?: string[];
      //   token?: string;
      //   tokenParsed?: {
      //     exp?: number;
      //     email?: string,
      //     name?: string,
      //     iat?: number;
      //     nonce?: string;
      //     sub?: string;
      //     session_state?: string;
      //     realm_access?: { roles: string[] };
      //     resource_access?: string[];
      //   };
      //   refreshToken?: string;
      //   refreshTokenParsed?: { nonce?: string };
      //   idToken?: string;
      //   idTokenParsed?: { nonce?: string };
      //   timeSkew?: number;
      // }
      return authenticationInstance
    },
    async getArkaneProfile(arkaneConnect) {
      const arkaneProfile = await arkaneConnect.api.getProfile()
      //   "userId": "46c87fcb-77ed-4433-a425-814569ca1672",
      //   "hasMasterPin": true,
      //   "username": "karel.striegel@arkane.network",
      //   "email": "karel.striegel@arkane.network",
      //   "firstName": "Karel",
      //   "lastName": "Striegel"
      // }
      return arkaneProfile
    },
  },
}
</script>
<style lang="sass" scope>
@import "../assets/sass/theme-variables"

.n3rd-header
  color: $black
  background-color: $charcoal
  border: 4px solid $primary
  /* top | right | bottom | left */
  border-style: none none inset none
  .arkane-button
    font-family: $heading-font
  .n3rd-logo
    color: $white
    font-family: $heading-font
  .GPL__toolbar-input
    color: $white
    font-family: $computer-font

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
