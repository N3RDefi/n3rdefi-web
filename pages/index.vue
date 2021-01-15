<template>
  <div class="container">
    <div>
      <Logo />
      <h1 class="title">N3RDefi</h1>
      <div class="links">
        <a
          href="https://nuxtjs.org/"
          target="_blank"
          rel="noopener noreferrer"
          class="nes-btn is-primary"
        >
          Documentation
        </a>
        <a
          href="https://github.com/nuxt/nuxt.js"
          target="_blank"
          rel="noopener noreferrer"
          class="nes-btn"
        >
          GitHub
        </a>
      </div>
    </div>
  </div>
</template>
<script>
/* Components */
import Logo from '~/components/Logo.vue'

export default {
  name: 'Home',
  components: {
    Logo,
  },
}
</script>
