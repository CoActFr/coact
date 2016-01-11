replacer = (replacePlugin, placeholder, target) ->
  replacePlugin new RegExp(placeholder, 'g'), target

bowerModule = require '../../bower.json'
moduleName = bowerModule.name
modulePlaceholder = '%module%'

srcPath = 'src'
assetsPlaceholder = '%assets%'
assetsFolder = 'assets'
lessFolder = 'less'
fontsFolder = 'fonts'
imagesFolder = 'images'
viewsFolder = 'views'
appFolder = 'app'
serverFolder = 'server'
routersFolder = 'routers'
modelsFolder = 'models'
assetsPath = "#{srcPath}/#{assetsFolder}"
lessPath = "#{srcPath}/#{lessFolder}"
fontsPath = "#{srcPath}/#{fontsFolder}"
imagesPath = "#{srcPath}/#{imagesFolder}"
viewsPath = "#{srcPath}/#{viewsFolder}"
appPath = "#{srcPath}/#{appFolder}"
serverPath = "#{srcPath}/#{serverFolder}"
routersPath = "#{srcPath}/#{serverFolder}/#{routersFolder}"
modelsPath = "#{srcPath}/#{serverFolder}/#{modelsFolder}"
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
wwwFontsFolder = 'fonts'
wwwFontsPath = "#{wwwPath}/#{wwwFontsFolder}"
wwwViewsFolder = 'views'
wwwViewsPath = "#{wwwPath}/#{wwwViewsFolder}"
routersPlaceholder = '%routers%'
modelsPlaceholder = '%models%'
wwwRoutersFolder = 'routers'
wwwModelsFolder = 'models'
wwwRoutersPath = "#{wwwPath}/#{wwwRoutersFolder}"
wwwModelsPath = "#{wwwPath}/#{wwwModelsFolder}"

config =

  paths:
    src:
      main: srcPath
      assets: assetsPath
      i18n: 'i18n'
      less: lessPath
      fonts: fontsPath
      images: imagesPath
      views: viewsPath
      app: appPath
      server:
        main: serverPath
        routers: routersPath
        models: modelsPath
      bower: bowerComponentsPath
    www:
      main: wwwPath
      routers: wwwRoutersPath
      models: wwwModelsPath
      scripts: scriptsPath
      styles: stylesPath
      img: imgPath
      fonts: wwwFontsPath
      views: wwwViewsPath

  folders:
    scripts:
      name: scriptsFolder
      replacer: (replace) -> replace scriptsPlaceholder, scriptsFolder
    styles:
      name: stylesFolder
      replacer: (replace) -> replace stylesPlaceholder, stylesFolder
    routers:
      name: wwwRoutersFolder
      replacer: (replace) -> replace routersPlaceholder, wwwRoutersFolder
    models:
      name: wwwModelsFolder
      replacer: (replace) -> replace modelsPlaceholder, wwwModelsFolder

  files:
    app: 'app.js'
    server: 'server.js'
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
    id: 'UA-68212799-1'
    domain: 'thecollaboractionfactory.com'

module.exports = config
