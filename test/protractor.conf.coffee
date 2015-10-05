process.env.HOST ?= 'http://127.0.0.1:7777/#'

global.testDirectory = __dirname

module.exports.config =
  framework: 'cucumber'

  cucumberOpts:
    require: 'step_definitions/'
    format: 'pretty'

  suites: {
    default:'features/landing.feature'
  }

  capabilities:
    browserName: process.env.BROWSER || 'firefox'
    version: ''
    platform: 'ANY'

  seleniumAddress: process.env.SELENIUM || null

  allScriptsTimeout: 20000
