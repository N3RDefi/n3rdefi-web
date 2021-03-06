/* global ethers hre task */
const fs = require('fs')

const basePath = '/contracts/facets/'

task('diamondABI', 'Generates ABI file for diamond, includes all ABIs of facets')
  .setAction(async () => {
    const files = fs.readdirSync(`.${  basePath}`)
    let abi = []
    for (const file of files) {
      const jsonFile = file.replace('sol', 'json')
      let json = fs.readFileSync(`./artifacts/${basePath}${file}/${jsonFile}`)
      json = JSON.parse(json)
      abi.push(...json.abi)
    }
    abi = JSON.stringify(abi)
    fs.writeFileSync('./diamondABI/diamond.json', abi)
    console.log('ABI written to diamondABI/diamond.json')
  })
