
module.exports = ($scope, $http,$sce , rasprobUrl) ->

  $scope.title = "Dashboard"

  fetch = ->
    $http.get(rasprobUrl.get() + "/stream")
      .success (res) ->
        $scope.file = new Blob response, {type: 'video/mp4'}
      .error (err) ->
        console.error err
  fetch()
