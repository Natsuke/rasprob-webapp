
module.exports = ($scope, rasprobUrl) ->

  $scope.url = rasprobUrl.get()

  $scope.setUrl = ->
    rasprobUrl.set()
      .then (res) ->
        $scope.url = rasprobUrl.get()
