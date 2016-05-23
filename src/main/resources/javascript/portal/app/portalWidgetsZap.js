var portalWidgetsZap = angular.module('portalWidgetsZapApp', []);

portalWidgetsZap.directive('portalWidget', function() {
    return {
        link: function(scope, element, attrs) {
            var widget = scope.widget;
            if(widget){
                element.addClass(Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_CLASS);
                element.attr("data-" + Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_NODEYPE, widget.name);
                widget.views.forEach(function(view){
                    if(view.key == "portal.edit"){
                        element.attr("data-" + Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_VIEW, "portal.edit");
                    }
                });
            }

            element.draggable({
                connectToSortable: Jahia.Portal.defaultConf.sortable_options.connectWith,
                helper: "clone",
                revert: "invalid",
                start: function(){
                    $(".portal_area").each(function(){
                        if(!$.trim($(this).html())){
                            $(this).addClass("empty-area")
                        }
                    });
                },
                stop: function(){
                    $(".portal_area").removeClass('empty-area');
                }
            });
        }
    };
});

portalWidgetsZap.controller('widgetsCtrl', ['$scope', function($scope) {
    $scope.widgets = portal.portalWidgetTypes;
    $scope.desiredWidget = "";
    $scope.query = "";

    $scope.init = function () {
        //TODO delete this
    };

    $scope.search = function (widget) {
        return !!((widget.name.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1 || widget.displayableName.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1));
    };

    $scope.isNew = function (widget) {
        return widget['new'];
    }
}]);