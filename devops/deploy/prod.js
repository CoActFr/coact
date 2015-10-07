module.exports = function (shipit) {

    shipit.blTask('installCoact', function () {
        return shipit.remote(
          "cd " + shipit.releasePath +
          " && npm config set production" +
          " && npm install --unsafe-perm" +
          " && forever stop coact" +
          " && cd www/ && IS_PROD=true forever start --uid 'coact' -a -o out.log -e err.log  server.js"
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
