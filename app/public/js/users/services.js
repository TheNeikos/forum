
angular.module("community.users", [])
.service("users", ["$http", function($http){
    function getAll() {
        return $http.get("/api/users")
    }

    return {
        all: getAll,
    }
}])

