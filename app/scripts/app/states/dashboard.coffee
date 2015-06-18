
### @ngInject ###
module.exports = ($stateProvider) ->
  $stateProvider
    .state('app.dashboard',
      url: '/dashboard'
      cache: false
      views:
        content:
          template: require '../../views/app/dashboard.html'
          controller: require '../../controllers/dashboard'
    )
