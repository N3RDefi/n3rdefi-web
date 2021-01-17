module.exports = {
  ssr: false,
  target: 'static',
  telemetry: false,
  /*
   ** Headers of the page
   */
  head: {
    title: 'N3RDefi',
    titleTemplate: '%s - A Defi eco-system',
    meta: [
      {
        charset: 'utf-8',
      },
      {
        name: 'viewport',
        content: 'width=device-width, initial-scale=1',
      },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || '',
      },
      {
        hid: 'keywords',
        name: 'keywords',
        content: 'defi, nft, crypto',
      },
    ],
    link: [
      {
        rel: 'icon',
        type: 'image/x-icon',
        href: '/favicon.ico',
      },
    ],
  },
  /*
   ** Customize the progress-bar color
   */
  loading: {
    color: '#ff6b4a',
  },
  // loadingIndicator: false,
  // loading: '~/components/Loading.vue',
  /*
   ** Global CSS
   */
  css: ['~/assets/sass/main.sass'],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [{ src: '@/plugins/quasar', ssr: false }],
  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxtjs/style-resources',
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://github.com/nuxt-community/dotenv-module
    '@nuxtjs/dotenv',
  ],
  /*
   ** Load SASS variables/lib for all components
   */
  styleResources: {
    sass: ['~/assets/sass/theme-variables.sass'],
  },
  /*
   ** Nuxt Firebase module configuration
   ** See https://firebase.nuxtjs.org/guide/getting-started/#full-configuration
   */
  env: {},
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {},
  },
}
