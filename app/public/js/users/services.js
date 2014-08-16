
angular.module("community.users", [])
.run(["$rootScope", "users", function($rootScope, users){
    $rootScope.current_user = users.current_user
}])
.service("users", ["$http", function($http){
    var cur_user = {}
    function getAll() {
        return $http.get("/api/users")
    }

    return {
        current_user: cur_user,
        all: getAll,
    }
}])

