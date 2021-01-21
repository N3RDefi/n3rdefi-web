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
            v-if="web3.web3Instance"
            class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm"
          >
            <Account :web3="web3" />
          </div>
          <div
            v-else
            class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm"
          >
            <pre>{{ web3 }}</pre>
            <Connect />
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

import Header from '~/components/Header.vue'
import SidebarLeft from '~/components/SidebarLeft.vue'
import PageStickyMenu from '~/components/PageStickyMenu.vue'
import Intro from '~/components/Intro.vue'
import Connect from '~/components/Connect.vue'
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
      getWeb3Instance: 'getWeb3Instance',
    }),
    web3: {
      get() {
        return this.$store.state.web3
      },
      async set(value) {
        /* Check Web3 Instance */
        const web3_ = await this.$web3()
        if (web3_) {
          this.$store.commit('WEB3INSTANCE', web3_)
        }
      },
    },
  },
  async beforeCreate() {
    /* Check Web3 Instance */
    const web3_ = await this.$web3()
    if (web3_) {
      this.$store.commit('WEB3INSTANCE', web3_)
    }
  },
  methods: {
    // async getBNBBalance(account) {
    //   const bnbBalance = await this.$web3.eth.getBalance(
    //     String(account),
    //     'latest'
    //   )
    //   const displayBalance = this.$web3.utils.fromWei(bnbBalance, 'ether')
    //   // console.log(`${displayBalance} ETH`)
    //   return displayBalance
    // },
    // async connectWallet(event) {
    //   /* `this` inside methods points to the Vue instance */
    //   /* `event` is the native DOM event */
    //   if (event) {
    //     console.log(event.target.tagName)
    //   }
    //   const wallet = await this.$web3.eth.accounts.wallet
    //   console.log(`connectWallet: ${wallet}!`)
    //   return wallet
    // },
    // async createWallet(event) {
    //   /* `this` inside methods points to the Vue instance */
    //   /* `event` is the native DOM event */
    //   if (event) {
    //     console.log(event.target.tagName)
    //   }
    //   const { wallet } = await this.$web3.eth.accounts.wallet.create(1)
    //   console.log(`wallet: ${wallet}!`)
    //   return wallet
    // },
    // createTransactiont(from, to, amount) {
    //   /* `event` is the native DOM event */
    //   if (event) {
    //     console.log(event.target.tagName)
    //   }
    //   /* `this` inside methods points to the Vue instance */
    //   console.log(`from Address: ${from}!`)
    //   console.log(`to Address: ${to}!`)
    //   console.log(`Amount: ${amount}!`)
    // },
  },
}
</script>
