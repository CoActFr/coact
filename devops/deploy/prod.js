module.exports = function (shipit) {

    shipit.blTask('installCoact', function () {
        return shipit.remote(
          "cd " + shipit.releasePath +
          " && npm config set production" +
          " && npm install --unsafe-perm" +
          " && forever stop " + shipit.config.foreverUID +
          " && cd www/ && COACT_PORT=" + shipit.config.serverPort + " forever start --uid '" + shipit.config.foreverUID + "' -a -o out.log -e err.log  server.js"
        );
    });

    shipit.blTask('install', function() {
      shipit.start(['installCoact'], function(err) {
        if(!err){
          shipit.log('Install done!');
        }
      })
    });
};
