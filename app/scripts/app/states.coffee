
app = angular.module 'web-app'

app.config (
  $stateProvider,
  $urlRouterProvider,
  $injector
) ->
  $urlRouterProvider
    .when('/app', '/app/dashboard')
    .otherwise('/app/dashboard')
  $stateProvider
    .state('app',
      url: '/app'
      abstract: true
      template: require '../views/index.html'
      controller: require '../controllers/index'
    )
  $injector.invoke require('./states/dashboard')
  $injector.invoke require('./states/settings')
  $injector.invoke require('./states/about')
