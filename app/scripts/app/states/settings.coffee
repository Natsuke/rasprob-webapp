
module.exports = ($stateProvider)->
  $stateProvider
    .state('app.settings',
      url: '/settings'
      views:
        content:
          template: require '../../views/app/settings.html'
          controller: require '../../controllers/settings'
    )
