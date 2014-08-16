
angular.module("community.index", ["ui.router"])
.config(["$stateProvider", function($stateProvider){
    $stateProvider.state("home", {
        url: '/',
        templateUrl: 'index/index',
        controller: ["$scope", "categories", "users", function($scope, categories, users) {
            categories.all().then(function(result){
                $scope.categories = result.data
            })
            users.all().then(function(result){
                $scope.users = result.data
            })
        }]
    })
}])
