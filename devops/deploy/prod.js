module.exports = function (shipit) {

    shipit.blTask('installCoact', function () {
        return shipit.remote(
          "cd " + shipit.releasePath +
          " && npm install --unsafe-perm" +
          " && ln -sf " + shipit.config.deployTo + "/current/www/ " +
          shipit.config.deployTo + "/www"
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
