import Vue from 'vue'
import '../assets/sass/quasar-overrides.sass'

import 'quasar/dist/quasar.addon.min.css'
import 'quasar-extras/material-icons'
import 'quasar-extras/material-icons/material-icons.css'

import Quasar from 'quasar/dist/quasar.umd.min'

Vue.use(Quasar, {
  config: {
    loading: false,
  },
})
