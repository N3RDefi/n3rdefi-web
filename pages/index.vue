<template>
  <q-layout view="lHh Lpr fff" class="bg-grey-1">
    <Header />
    <SidebarLeft />
    <q-page-container class="GPL__page-container">
      <!-- <router-view /> -->
      <q-page padding>
        <!-- First Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Intro />
          </div>
          <div
            v-if="!web3.account"
            class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm"
          >
            <Connect :web3="web3" />
          </div>
          <div
            v-if="web3.web3Instance && web3.account"
            class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm"
          >
            <Account :web3="web3" />
          </div>
        </div>
        <!-- END First Row -->
        <!-- Second Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <NFTGenerator />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <NFTHero />
          </div>
        </div>
        <!-- END Second Row -->
        <!-- Third Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <D3fi />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Seal />
          </div>
        </div>
        <!-- END Third Row -->
        <!-- Fourth Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <G3fi />
          </div>
        </div>
        <!-- END Fourth Row -->
        <!-- Fifth Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Incubator />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Academy />
          </div>
          <!-- END Fifth Row -->
        </div>
      </q-page>
      <PageStickyMenu />
    </q-page-container>
  </q-layout>
</template>
<script>
import { mapMutations, mapGetters } from 'vuex'
/* Enums and Helper */
import { networks } from '~/util/networks'
import { networkFilter } from '~/util/networkFilter'

import Header from '~/components/Header.vue'
import SidebarLeft from '~/components/SidebarLeft.vue'
import PageStickyMenu from '~/components/PageStickyMenu.vue'
import Intro from '~/components/Intro.vue'
import Connect from '~/components/Connect.vue'
import Account from '~/components/Account.vue'
import NFTGenerator from '~/components/NFTGenerator.vue'
import NFTHero from '~/components/NFTHero.vue'
import D3fi from '~/components/D3fi.vue'
import Seal from '~/components/Seal.vue'
import G3fi from '~/components/G3fi.vue'
import Incubator from '~/components/Incubator.vue'
import Academy from '~/components/Academy.vue'

export default {
  name: 'N3RD',
  components: {
    Header,
    SidebarLeft,
    PageStickyMenu,
    Intro,
    Connect,
    Account,
    NFTGenerator,
    NFTHero,
    D3fi,
    Seal,
    G3fi,
    Incubator,
    Academy,
  },
  data() {
    return {}
  },
  computed: {
    ...mapGetters({
      getWeb3: 'getWeb3',
    }),
    web3: {
      get() {
        return this.$store.state.web3
      },
      set(value) {
        // this.$store.commit('SET_WEB3_INSTANCE', value)
      },
    },
  },
  async beforeCreate() {
    /* Check Web3 Instance */
    const web3_ = await this.$web3()
    if (web3_) {
      this.$store.commit('SET_WEB3_INSTANCE', true)
      if (web3_ && web3_.isMetaMask === true) {
        this.$store.commit('SET_IS_METAMASK', true)
      }
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log('MetaMask loaded successfully!')
      } else {
        console.log('Please load MetaMask!')
      }
    }
  },
  methods: {
    async loadAccount() {
      /* Load Network, Account and Balance/s */
      const account = await this.$web3.getAccount()
      if (account[0] && account[0] !== '') {
        this.$store.commit('SET_ACCOUNT', account)
        const chainIdHEX = await this.$web3.getChainId(account)
        this.$store.commit('SET_CHAIN_ID_HEX', chainIdHEX)
        const chainName = networkFilter(chainIdHEX)
        this.$store.commit('SET_CHAIN_NAME', chainName)
        const balance = await this.$web3.getBalance(account)
        this.$store.commit('SET_BALANCE', balance)
        return true
      } else {
        return false
      }
    },
  },
}
</script>
