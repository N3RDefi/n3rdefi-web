module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  settings: {
    'import/resolver': {
      node: {
        extensions: ['.js', '.jsx', '.vue', '.ts'],
      },
    },
    // @SN 25/04/2019, Resolves import issue: https://stackoverflow.com/questions/55174647/nuxt-js-importing-vuex-emits-eslintimport-no-extraneous-dependencies-error
    'import/core-modules': [
      'vue',
      'vuex',
      'axios',
      '@nuxt/config',
      'dotenv',
      'vue-meta',
    ],
  },
  parserOptions: {
    parser: 'babel-eslint',
    ecmaVersion: 9,
    sourceType: 'module',
  },
  extends: [
    '@nuxtjs',
    'plugin:nuxt/recommended',
    'plugin:vue/essential',
    'eslint:recommended',
    'airbnb-base',
    'plugin:prettier/recommended',
    'plugin:vue/recommended',
    'prettier',
    'prettier/vue',
  ],
  plugins: ['vue', '@typescript-eslint', 'prettier', 'vue'],
  globals: {
    page: true,
    $nuxt: true,
  },
  rules: {
    'no-console': 'off',
    'no-shadow': 'off',
    'no-param-reassign': 'off',
    'prettier/prettier': ['error'],
    'no-nested-ternary': 0,
    'import/prefer-default-export': 0,
    'no-extra-boolean-cast': 0,
    'no-prototype-builtins': 0,
    'no-unused-vars': ['warn', { args: 'none' }],
    'vue/attribute-hyphenation': 0,
    'vue/prop-name-casing': ['error', 'camelCase'],
    'no-unneeded-ternary': 0,
    // "vue/attribute-hyphenation": ["error", "never"],
    'vue/order-in-components': ['error'],
    // "vue/component-name-in-template-casing": [
    //   "error",
    //   "PascalCase",
    //   {
    //     registeredComponentsOnly: false,
    //     ignores: [],
    //   },
    // ],
    'import/extensions': [
      'error',
      'always',
      {
        js: 'never',
        ts: 'never',
      },
    ],
  },
}
