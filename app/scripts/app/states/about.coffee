
module.exports = ($stateProvider) ->
  $stateProvider
    .state('app.about',
      url:'/about'
      views:
        content:
          template: require '../../views/app/about.html'
          controller: require '../../controllers/about'
    )
