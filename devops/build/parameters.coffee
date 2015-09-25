replacer = (replacePlugin, placeholder, target) ->
  replacePlugin new RegExp(placeholder, 'g'), target

bowerModule = require '../../bower.json'
moduleName = bowerModule.name
modulePlaceholder = '%module%'

srcPath = 'src'
assetsPlaceholder = '%assets%'
assetsFolder = 'common/assets'
lessFolder = 'common/less'
fontsFolder = 'common/fonts'
imagesFolder = 'common/images'
assetsPath = "#{srcPath}/#{assetsFolder}"
lessPath = "#{srcPath}/#{lessFolder}"
fontsPath = "#{srcPath}/#{fontsFolder}"
imagesPath = "#{srcPath}/#{imagesFolder}"
bowerComponentsPath = "bower_components"

wwwPath = 'www'
scriptsPlaceholder = '%scripts%'
scriptsFolder = 'js'
scriptsPath = "#{wwwPath}/#{scriptsFolder}"
stylesPlaceholder = '%styles%'
stylesFolder = 'css'
stylesPath = "#{wwwPath}/#{stylesFolder}"
imgFolder = 'img'
imgPath = "#{wwwPath}/#{imgFolder}"

config =

  paths:
    src:
      main: srcPath
      assets: assetsPath
      i18n: 'i18n'
      less: lessPath
      fonts: fontsPath
      images: imagesPath
      bower: bowerComponentsPath
    www:
      main: wwwPath
      scripts: scriptsPath
      styles: stylesPath
      img: imgPath

  folders:
    scripts:
      name: scriptsFolder
      replacer: (replace) -> replace scriptsPlaceholder, scriptsFolder
    styles:
      name: stylesFolder
      replacer: (replace) -> replace stylesPlaceholder, stylesFolder

  files:
    app: 'app.js'
    styles: 'app.css'
    templates: 'templates.js'
    vendors:
      scripts: 'vendor.js'
      styles: 'vendor.css'

  angular:
    module:
      name: moduleName
      placeholder: modulePlaceholder
      # Include the replace in the streams where needed
      replacer: (replace) -> replace modulePlaceholder, moduleName

  analytics:
    id: 'UA-XXXXXXXX-X'
    domain: 'doma.in'

module.exports = config
