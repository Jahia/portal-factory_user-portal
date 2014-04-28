var portalToolbar = angular.module('portalToolbar', []);

portalToolbar.directive('decodehtml', function($timeout) {
    return {
        link: function(scope, element, attrs) {
            setTimeout(function(){
                element.text($("<div></div>").html(element.text()).text());
            }, 0)
        }
    };
});

portalToolbar.controller('widgetsCtrl', function ctrl($scope) {
    $scope.modalId = "";
    $scope.widgets = portal.portalWidgetTypes;
    $scope.desiredName = "";
    $scope.desiredWidget = "";
    $scope.query = "";

    $scope.init = function (modalId) {
        $scope.modalId = modalId;
    };

    $scope.selectWidget = function (nodetype) {
        $scope.desiredWidget = nodetype;
    };

    $scope.addWidget = function () {
        if ($scope.desiredName.length > 0 && $scope.desiredWidget.length > 0) {
            portal.addNewWidget($scope.desiredWidget, $scope.desiredName);
            $scope.cancel();
        }
    };

    $scope.cancel = function () {
        $('#' + $scope.modalId).modal('hide');
        $scope.desiredName = "";
        $scope.desiredWidget = "";
    };

    $scope.search = function (widget) {
        return !!((widget.name.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1 || widget.displayableName.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1));
    };
});

portalToolbar.controller('tabCtrl', function test($scope) {
    $scope.modalId = "";
    $scope.edit = false;
    $scope.form = [];

    $scope.init = function (type, modalId) {
        $scope.modalId = modalId;
        $scope.edit = (type && type == "edit");
        $('#' + modalId).on('show', function () {
            $scope.$apply(function(){
                $scope.form = {
                    name: $scope.edit ? $("<div></div>").html(portal.portalCurrentTab.displayableName).text() : '',
                    template: portal.portalCurrentTab.templateKey,
                    widgetSkin: portal.portalCurrentTab.skinKey,
                    allowedTemplates: portal.portalTabTemplates,
                    allowedWidgetsSkins: portal.portalTabSkins
                }
            });
        });
    };

    $scope.cancel = function () {
        $('#' + $scope.modalId).modal('hide');
        $scope.form = [];
    };

    $scope.submit = function (isNew) {
        portal.saveTabForm($scope.transformForm(), function () {
            $scope.$apply(function () {
                $scope.form = [];
            });
        }, isNew);
    };

    $scope.transformForm = function () {
        return [
            {"name":"jcr:title", "value":$scope.form.name},
            {"name":"j:templateName", "value":$scope.form.template},
            {"name":"j:widgetSkin", "value":$scope.form.widgetSkin}
        ];
    }
});

portalToolbar.controller('navCtrl', function test($scope) {
    $scope.canBeDeleted = false;
    $scope.tabs = portal.portalTabs;

    $scope.init = function () {
        $(".toolbar-tooltip").tooltip();
    };

    $scope.isCurrentTab = function (tab) {
        return tab.path == portal.portalTabPath;
    };

    $scope.getTabHref = function (tab) {
        return portal.baseURL + tab.path + ".html";
    };

    $scope.deleteTab = function(){
        if($scope.canBeDeleted){
            portal.deleteCurrentTab();
        }
    };

    $scope.copyModel = function(){
        portal.initPortalFromModel();
    };

    $scope.lock = function(){
        portal.lockPortal();
    };

    $scope.unlock = function(){
        portal.unlockPortal();
    }
});