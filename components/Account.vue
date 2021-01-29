<template>
  <q-card flat bordered class="n3rd-card n3rd-account-card">
    <q-card-section>
      <div class="text-h6">
        {{ title }}
      </div>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>{{ user.account[0] }}</p>
      <p>Balance: {{ user.balance }}</p>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>Web3 Instance: {{ user.web3Instance }}</p>
      <p>Is MetaMask: {{ user.isMetaMask }}</p>
      <p>Network: {{ networkFilter(user.chainIdHEX, 'name') }}</p>
      <p>Chain Id HEX: {{ user.chainIdHEX }}</p>
      <p>Network ID: {{ networkFilter(user.chainIdHEX, 'id') }}</p>
    </q-card-section>
    <q-card-section class="q-pt-none">
      <p>Arkane userId: {{ profile.userId }}</p>
      <p>Arkane hasMasterPin: {{ profile.hasMasterPin }}</p>
      <p>Arkane username: {{ profile.username }}</p>
      <p>Arkane email: {{ profile.email }}</p>
      <p>Arkane firstName: {{ profile.firstName }}</p>
      <p>Arkane lastName: {{ profile.lastName }}</p>
    </q-card-section>
    <q-card-section>
      <q-btn
        v-if="!profile.userId"
        flat
        color="white"
        class="bg-primary full-width q-mb-sm"
        label="Connect Arkane"
        @click="connectArkane()"
      />
      <q-btn
        outline
        color="grey-8"
        class="full-width q-mb-sm"
        label="Test Transaction"
        @click="
          sendTransaction(
            (from = 'test'),
            (to = 'test'),
            (value = 'test'),
            (gas = 'test'),
            (gasPrice = 'test')
          )
        "
      />
      <q-btn
        v-if="user"
        outline
        color="primary"
        class="full-width"
        label="Request Permissions"
        @click="requestPermissions()"
      />
    </q-card-section>
    <q-card-section class="q-pt-none">
      <pre>User: {{ user }}</pre>
      <pre>Profile: {{ profile }}</pre>
    </q-card-section>
  </q-card>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* Arkane Connect for Wallet */
import { ArkaneConnect } from '../node_modules/@arkane-network/arkane-connect'
/* Network helper */
import { networkFilter } from '../util/networkFilter'
/* LFG */
export default {
  name: 'Account',
  data() {
    return {
      title: 'Account',
    }
  },
  computed: {
    ...mapState(['web3', 'profile', 'user']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
    }),
  },
  // async beforeCreate() {
  //   /* Check ArkaneProvider Instance */
  //   const arkaneProvider = await this.$web3.connectArkaneProvider()
  //   if (arkaneProvider) {
  //     console.log(
  //       '%c ArkaneProvider loaded successfully!',
  //       'background: blue; color: white'
  //     )
  //   } else {
  //     console.log(
  //       '%c Please connect arkaneProvider!',
  //       'background: red; color: white'
  //     )
  //   }
  // },
  methods: {
    networkFilter(chainId, filterType) {
      return networkFilter(chainId, filterType)
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
    async sendTransaction(from, to, value, gas, gasPrice) {
      try {
        const sent = await this.$web3.sendTransaction(
          from,
          to,
          value,
          gas,
          gasPrice
        )
        // Handle the result
        console.log(sent)
      } catch (error) {
        // Handle the error
        console.error(error)
      }
    },
    async requestPermissions() {
      await window.ethereum
        .request({
          method: 'eth_requestAccounts',
          params: [{ eth_accounts: {} }],
        })
        .then((permissions) => {
          const accountsPermission = permissions.find(
            (permission) => permission.parentCapability === 'eth_accounts'
          )
          if (accountsPermission) {
            console.log('eth_accounts permission successfully requested!')
          }
        })
        .catch((error) => {
          if (error.code === 4001) {
            // EIP-1193 userRejectedRequest error
            console.log('Permissions needed to continue.')
          } else {
            console.error(error)
          }
        })
    },
  },
}
</script>
<style lang="sass">
@import "../assets/sass/theme-variables"

.n3rd-account-card
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
