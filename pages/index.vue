<template>
  <q-layout view="lHh Lpr fff" class="bg-grey-1">
    <Header />
    <SidebarLeft />
    <q-page-container class="GPL__page-container">
      <!-- <router-view /> -->
      <q-page padding>
        <!-- First Row - Intro & Connect -->
        <div class="row items-center justify-evenly">
          <div class="col">
            <Intro />
          </div>
          <div class="col">
            <Connect />
          </div>
        </div>
        <!-- END First Row -->
        <!-- Second Row - Intro & Connect -->
        <div class="row items-center justify-evenly">
          <div class="col-6">
            <NFTGenerator />
          </div>
          <div class="col-6">
            <NFTHero />
          </div>
        </div>
        <!-- END Second Row -->
        <!-- Third Row - Intro & Connect -->
        <div class="row items-center justify-evenly">
          <div class="col">
            <D3fi />
          </div>
          <div class="col">
            <Seal />
          </div>
        </div>
        <!-- END Third Row -->
        <!-- Fourth Row - Intro & Connect -->
        <div class="row items-center justify-evenly">
          <div class="col">
            <G3fi />
          </div>
        </div>
        <!-- END Fourth Row -->
        <!-- Fifth Row - Intro & Connect -->
        <div class="row items-center justify-evenly">
          <div class="col">
            <Incubator />
          </div>
          <div class="col">
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
  name: 'GooglePhotosLayout',
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
    return {
      user: {},
      lorem:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    }
  },
}
</script>
