
angular.module("community.bars", [])
.directive("upperbar", ["$rootScope", "users", function($rootScope, users){
    return {
        restrict: "E",
        replace: false,
        templateUrl: "bars/upperbar",
        link: function(scope) {
        }
    }
}])

