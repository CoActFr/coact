module.exports = function (shipit) {
    require('shipit-deploy')(shipit);

    shipit.initConfig({
        default: {
            workspace: '/tmp/coact',
            repositoryUrl: 'git@github.com:AubryH/coact.git',
            ignores: ['.git', 'node_modules'],
            shallowClone: true,
        },
        prod: {
            servers: 'root@212.227.108.147',
            branch: 'master',
            deployTo: '/var/www/coact',
            serverPort: 5010,
            foreverUID: 'coact',
            keepReleases: 2
        },
        preprod: {
            servers: 'root@212.227.108.147',
            branch: 'staging',
            deployTo: '/var/www/coact-preprod',
            serverPort: 7777,
            foreverUID: 'coactpreprod',
            keepReleases: 1
        }
    });

    shipit.on('published', function() {
        return shipit.start('install');
    });

    if(['prod', 'preprod'].indexOf(shipit.environment) > -1) {
      require('./devops/deploy/prod.js')(shipit);
    } else {
      console.log("Unknwown environment: " + shipit.environment);
      exit(1);
    }
};
