
module.exports = ($scope, $sce, rasprobUrl) ->

  $scope.title = "Dashboard"

  fetch = ->
    $scope.url = $sce.trustAsResourceUrl(rasprobUrl.get() + "/stream")
  fetch()
