var app = angular.module('videoApp', ['ui.bootstrap']);

    app.controller('buttonController', function($scope, $http){
        		
		$http.get('lib/json/categories.json').success(function(data){
			$scope.menuItems = data;
		});

		$http.get('lib/json/videos.json').success(function(data){
			$scope.videoList = data;
		});
		
		$scope.playList = [];
		
		$scope.linkFilter = function(filterValue){
			$scope.videoSearch = filterValue;
		};
		
		$scope.addToPlaylist = function(link, title, id){
			var dup;
			if(id){
				angular.forEach($scope.playList, function(eachmovie){
					if(id.toLowerCase() === eachmovie.id.toLowerCase()){
						dup = true;
					}
				});
			if(!dup){
				$scope.playList.push({link:link, title:title, id:id});
			}
			}
		};
	 
		$sendPlaylist = function(){
			$scope.playList = [];
		};
		
		$scope.play = function(link, title){
			$scope.sampleVideo=({link:link, title:title});
			$scope.shouldBeOpen = true;
		};
		
		$scope.close = function () {
			//$scope.closeMsg = 'I was closed at: ' + new Date();
			$scope.sampleVideo = [];
			$scope.shouldBeOpen = false;
		  };
  
		$scope.opts = {
			backdropFade: true,
			dialogFade:true
		  };
		  
		$scope.openPlayList = function(){
			$scope.showPlayList = true;
		};
		
		$scope.closePlayList = function () {
			//$scope.closeMsg = 'I was closed at: ' + new Date();
			$scope.showPlayList = false;
		  };
		  
		$scope.removeFromPlayList = function(array,$index){
			$scope[array].splice($index,1);
		};
		
 });
