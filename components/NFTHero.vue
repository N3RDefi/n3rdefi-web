<template>
  <div class="row">
    <div v-for="n in myNFTs" :key="`sm-${n.id}`" class="col-4 q-px-sm">
      <ImgCard :nft="n" />
    </div>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import ImgCard from './Cards/ImgCard.vue'

export default {
  name: 'NFTHero',
  components: {
    ImgCard,
  },
  data() {
    return {
      title: 'N3RDy NFT',
      myNFTs: [
        {
          id: 1,
          title: '8 bit Arcade Machine',
          image: '../../assets/images/nfts/8-bit-arcade-machine.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 2,
          title: 'Cute Pink Unicorm',
          image: '../../assets/images/nfts/cute-pink-unicorn.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 3,
          title: 'Pixel Speech Bubbles',
          image: '../../assets/images/nfts/pixel-speech-bubbles.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 4,
          title: 'Retro Arcade Machine',
          image: '../../assets/images/nfts/retro-arcade-slot-machine.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 5,
          title: 'Pixel Pirates',
          image: '../../assets/images/nfts/pixel-art-pirate-knight-cowboy-queen.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 6,
          title: 'Liewe Pixie',
          image: '../../assets/images/nfts/pixel-art-cute-witch-flying-broom.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 7,
          title: '8 bit Planets',
          image: '../../assets/images/nfts/pixel-art-cartoon-planes.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 8,
          title: 'Pixel Star',
          image: '../../assets/images/nfts/pixel-star.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 9,
          title: 'Beard Man',
          image: '../../assets/images/nfts/pixel-art-beard-man.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 10,
          title: 'Old Computer',
          image: '../../assets/images/nfts/pixel-art-old-computer.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 11,
          title: '8 bit Dragonz',
          image: '../../assets/images/nfts/pixel-art-dragon-8-bit-game-character.jpg',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
        {
          id: 12,
          title: '8 Bit Arcade',
          image: '../../assets/images/nfts/8-bit-arcade.png',
          link: '',
          price: '',
          address: '',
          owner: '',
          category: '',
        },
      ],
    }
  },
  computed: {
    ...mapGetters({
      getNfts: 'getNfts',
    }),
    nfts: {
      get() {
        return this.$store.state.nfts
      },
      set(value) {
        this.$store.commit('GENERATE_NFT', value)
      },
    },
  },
}
</script>
<style lang="sass">
@import "./assets/sass/theme-variables"

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
