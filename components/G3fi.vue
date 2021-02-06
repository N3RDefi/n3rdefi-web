<template>
  <div class="row items-start justify-evenly n3rd-defi">
    <div class="col-4 col-lg-4 col-md-3 col-sm-12 col-xs-12 q-pr-sm">
      <q-card outlinee bordered class="n3rd-defi-intro n3rd-defi-img">
        <q-card-section>
          <div class="n3rd-defi-title">D3Fi</div>
          <div class="n3rd-defi-text">
            N3RDefi is a safe environment, where fellow N3RDs can come together to form a community. Being part of a community offers trust, strength,
            safety and commitment to a united cause, this help reduce and even eliminate bad actors.
          </div>
        </q-card-section>
        <q-card-section v-if="user.account" class="n3rd-defi-buttons justify-end self-end" align="right">
          <q-btn outline dense color="white" label="aTokens" class="full-width q-mb-sm" @click="nextStep()" />
          <q-btn outline dense color="secondary" label="Deposit" class="full-width q-mb-sm q-mr-sm" @click="goHome()" />
          <q-btn outline dense color="primary" label="Borrow" class="full-width q-mb-sm" @click="nextStep()" />
        </q-card-section>
      </q-card>
      <q-card outlinee bordered class="n3rd-tvl n3rd-tvl-img">
        <q-card-section align="center">
          <img src="~assets/images/aavegotchi.gif" width="120px" title="AAVE" />
        </q-card-section>
        <q-card-section>
          <div class="n3rd-tvl-title">Aavegotchi</div>
          <div class="n3rd-tvl-ghst items-center justify-center">GHST $<span class="n3rd-tvl-text"> 1000</span></div>
          <div class="n3rd-tvl-n3rdy items-center justify-center">N3RDy $<span class="n3rd-tvl-text"> 10000</span></div>
        </q-card-section>
        <q-card-section align="center">
          <img src="~assets/images/ghst_coin.gif" width="100px" title="Aavegotchi" />
          <q-btn
            v-if="user.account"
            outline
            dense
            color="white"
            label="Stake $GHST"
            class="bg-primary full-width q-mb-sm q-mr-sm"
            @click="stakeGHST()"
          />
          <q-btn
            v-if="user.account"
            outline
            dense
            color="black"
            label="Stake $N3RDy"
            class="bg-secondary full-width q-mb-sm q-mr-sm"
            @click="stakeN3RDy()"
          />
        </q-card-section>
      </q-card>
    </div>
    <div class="col-8 col-lg-8 col-md-9 col-sm-12 col-xs-12 no-padding q-pl-md">
      <table class="aave-table full-width">
        <thead>
          <tr>
            <th colspan="2" align="left">Asset</th>
            <th align="center">Market Size</th>
            <th align="center">Total borrowed</th>
            <th align="center">
              Deposit<br />
              APY
            </th>
            <th align="center">
              Variable<br />
              Borrow APR
            </th>
            <th align="center">
              Stable<br />
              Borrow APR
            </th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aDAI.svg" width="24px" title="DAI" />
            </td>
            <td class="token-title">DAI</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aUSDC.svg" width="24px" title="aUSDC" />
            </td>
            <td class="token-title">USD Coin (USDC)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aTUSD.svg" width="24px" title="aTUSD" />
            </td>
            <td class="token-title">TrueUSD (TUSD)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aUSDT.svg" width="24px" title="aUSDT" />
            </td>
            <td class="token-title">USDT Coin (USDT)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aSUSD.svg" width="24px" title="aSUSD" />
            </td>
            <td class="token-title">sUSD</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aBUSD.svg" width="24px" title="aBUSD" />
            </td>
            <td class="token-title">Binance USD (BUSD)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aGUSD.svg" width="24px" title="aGUSD" />
            </td>
            <td class="token-title">Gemini Dollar (GUSD)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aWETH.svg" width="24px" title="aWETH" />
            </td>
            <td class="token-title">Wrapped ETH</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aAAVE.svg" width="24px" title="aAAVE" />
            </td>
            <td class="token-title">Aave (AAVE)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aUNI.svg" width="24px" title="aUNI" />
            </td>
            <td class="token-title">Uniswap</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aYFI.svg" width="24px" title="aYFI" />
            </td>
            <td class="token-title">yearn.finance (YFI)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aBAT.svg" width="24px" title="aBAT" />
            </td>
            <td class="token-title">Basic Attention Token</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aREN.svg" width="24px" title="aREN" />
            </td>
            <td class="token-title">REN</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aENJ.svg" width="24px" title="aENJ" />
            </td>
            <td class="token-title">EnjinCoin (ENJ)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aKNC.svg" width="24px" title="aKNC" />
            </td>
            <td class="token-title">Kyber Network (KNC)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aLINK.svg" width="24px" title="aLINK" />
            </td>
            <td class="token-title">ChainLink (LINK)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aMANA.svg" width="24px" title="aMANA" />
            </td>
            <td class="token-title">Decentraland</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aMKR.svg" width="24px" title="aMKR" />
            </td>
            <td class="token-title">Maker (MKR)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aSNX.svg" width="24px" title="aSNX" />
            </td>
            <td class="token-title">SNX</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aWBTC.svg" width="24px" title="aWBTC" />
            </td>
            <td class="token-title">WBTC Coin (WBTC)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aZRX.svg" width="24px" title="aZRX" />
            </td>
            <td class="token-title">0x Coin (ZRX)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aCRV.svg" width="24px" title="aCRV" />
            </td>
            <td class="token-title">Curve DAO Token</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
          <tr>
            <td>
              <img src="~assets/images/aTokens/aBAL.svg" width="24px" title="aBAL" />
            </td>
            <td class="token-title">Balancer (BAL)</td>
            <td align="center" class="token-price">$ 72.02M</td>
            <td align="center" class="token-price">$59.03M</td>
            <td align="center" class="purple">7.82 %</td>
            <td align="center" class="green">11.45 %</td>
            <td align="center" class="orange">16.45 %</td>
            <td>
              <q-btn outline dense color="white" label="Deposit" class="bg-primary q-mb-sm q-mr-sm" @click="deposit()" />
              <q-btn outline dense color="black" label="Borrow" class="bg-secondary q-mb-sm" @click="borrow()" />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* LFG */
export default {
  name: 'G3fi',
  data() {
    return {
      title: 'G3fi',
    }
  },
  computed: {
    ...mapState(['web3', 'user', 'profile', 'aaveTokens']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
      getAaveTokens: 'getAaveTokens',
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
    aaveTokens: {
      get() {
        return this.$store.state.aaveTokens
      },
      set(value) {
        this.$store.commit('SET_AAVE_TOKENS', value)
      },
    },
  },
  methods: {
    nextStep() {
      if (this.user.step === 2) {
        $nuxt.$store.dispatch('setStep', 0)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step + 1)
      }
    },
    goBack() {
      if (this.user.step === 0) {
        $nuxt.$store.dispatch('setStep', 2)
      } else {
        $nuxt.$store.dispatch('setStep', this.user.step - 1)
      }
    },
    goHome() {
      $nuxt.$store.dispatch('setStep', 1)
    },
    stakeGHST() {
      console.log('Stake GHST')
    },
    stakeN3RDy() {
      console.log('Stake N3RDy')
    },
  },
}
</script>
<style lang="sass" scoped>
@import "../assets/sass/theme-variables"

.n3rd-defi
  min-height: 320px
  .n3rd-defi-title
    color: $primary
    font-family: $heading-font
    font-size: 26px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 10px 10px 30px 10px
    text-align: left
  .n3rd-defi-subtitle
    color: $secondary
    font-family: $heading-font
    font-size: 14px
    line-height: 20px
    font-weight: 400
    letter-spacing 0.16px
    margin: 0 10px 25px 10px
    text-align: left
  .n3rd-defi-text
    width: 70%
    color: $white
    font-family: $computer-font
    font-size: 16px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: left
  .n3rd-defi-buttons
    margin: 0 10px
.n3rd-defi-img
  background-image: url('../assets/images/defi.gif')
  background-size: cover
  background-repeat: no-repeat
  background-position: top center
  overflow: display
  padding: 0

.n3rd-tvl
  margin-top: 20px
  min-height: 320px
  .n3rd-tvl-title
    color: $white
    font-family: $heading-font
    font-size: 22px
    line-height: 30px
    font-weight: 400
    letter-spacing 0.16px
    word-spacing 2px
    margin: 0 auto
    text-align: center
  .n3rd-tvl-subtitle
    color: $primary
    font-family: $computer-font
    font-size: 28px
    line-height: 20px
    font-weight: 600
    letter-spacing 0.16px
    margin: 20px 10px 25px 10px
    text-align: center
  .n3rd-tvl-ghst
    color: $primary
    font-family: $computer-font
    font-size: 28px
    line-height: 20px
    font-weight: 600
    letter-spacing 0.16px
    margin: 20px 10px 25px 10px
    text-align: center
  .n3rd-tvl-n3rdy
    color: $secondary
    font-family: $computer-font
    font-size: 28px
    line-height: 20px
    font-weight: 600
    letter-spacing 0.16px
    margin: 20px 10px 0 10px
    text-align: center
  .n3rd-tvl-text
    width: 70%
    color: $white
    font-family: $button-font
    font-size: 26px
    line-height: 26px
    font-weight: 400
    margin: 0 10px 10px 10px
    text-align: left
  .n3rd-tvl-buttons
    margin: 0 10px
.n3rd-tvl-img
  background-image: url('../assets/images/star-background-full-bg.jpg')
  background-size: cover
  background-repeat: no-repeat
  background-position: top center
  overflow: display
  padding: 0

.aave-table
  width: 100%
  th
    font-weight: 600
  td
    font-family: $computer-font
    font-weight: 400
  .token-title
    font-size: 16px
    font-weight: 400
  .token-price
    font-size: 16px
    font-weight: 400
  .purple
    font-size: 16px
    color: $purple
    font-weight: 400
  .green
    font-size: 16px
    color: $warning
    font-weight: 400
  .orange
    font-size: 16px
    color: $positive
    font-weight: 400

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
  .n3rd-defi-img
    background-image: url('../assets/images/defi.gif')
    background-size: cover
    background-repeat: no-repeat
    background-position: top 20% !important
    overflow: display
    padding: 0

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
