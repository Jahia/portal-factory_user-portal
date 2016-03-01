<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%@ taglib prefix="portal" uri="http://www.jahia.org/tags/portalLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="nodetype" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="portalContext" type="org.jahia.modules.portal.service.bean.PortalContext"--%>
<%--@elvariable id="portalTab" type="org.jahia.services.content.JCRNodeWrapper"--%>

<c:set var="portalIsModel" value="${portalContext.model}"/>
<c:set var="portalIsEditable" value="${portalContext.editable}"/>
<c:set var="portalIsCustomizable" value="${portalContext.customizable}"/>
<c:set var="portalIsEnabled" value="${portalContext.enabled}"/>
<c:set var="portalIsLocked" value="${portalContext.lock}"/>

<bootstrap:addCSS/>
<template:addCacheDependency path="${portalContext.path}"/>
<c:if test="${!portalIsModel}">
    <template:addCacheDependency path="${portalContext.modelPath}"/>
</c:if>
<template:addResources type="javascript" resources="jquery.min.js" />
<template:addResources type="javascript" resources="portal/jquery-ui.min.js" />
<template:addResources type="javascript" resources="portal/vendor/angular.min.js" />
<template:addResources type="javascript" resources="bootstrap-alert.js"/>
<template:addResources type="javascript" resources="bootstrap-dropdown.js"/>
<template:addResources type="javascript" resources="bootstrap-modal.js"/>
<template:addResources type="javascript" resources="bootstrap-transition.js"/>
<template:addResources type="javascript" resources="bootstrap-tooltip.js" />
<template:addResources type="javascript" resources="bootstrap-collapse.js" />
<template:addResources type="javascript" resources="portal/app/portalToolbar.js" />
<template:addResources type="css" resources="portal-toolbar.css"/>
<c:set var="siteNode" value="${renderContext.site}"/>

<div id="portal_toolbar" class="portal_toolbar">
    <div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <h1><fmt:message key="jnt_portalToolbar.processing"/></h1>
        </div>
        <div class="modal-body">
            <div class="progress progress-striped active">
                <div class="bar" style="width: 100%;"></div>
            </div>
        </div>
    </div>

    <div ng-controller="navCtrl" ng-init="init()">
        <c:if test="${portalIsModel && portalIsEditable}">
            <div class="alert alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <strong>Warning!</strong> <fmt:message key="jnt_portalToolbar.model.editable"/>
            </div>
        </c:if>
        <c:if test="${portalIsModel && !portalIsEditable && portalIsCustomizable}">
            <div class="alert alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <strong>Warning!</strong> <fmt:message key="jnt_portalToolbar.model.notEditable"/>
            </div>
        </c:if>

        <ul class="nav nav-tabs">
            <li ng-class="isCurrentTab(tab) ? 'active' : ''" ng-repeat="tab in tabs">
                <a ng-href="{{tab.url}}" decodehtml>{{tab.displayableName}}</a>
            </li>

            <li class="right">
                    <div class="user-box dropdown">
                        <a class="dropdown-toggle btn" data-toggle="dropdown" href="#">
                            <fmt:message key="label.actions"/>&nbsp;
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                                <c:if test="${portalIsEditable && !portalIsLocked}">
                                    <li>
                                        <a href="#newTabModal" data-toggle="modal">
                                            <i class="icon-plus"></i>
                                            <fmt:message key="jnt_portalToolbar.addTab.menu"/>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#editTabModal" data-toggle="modal">
                                            <i class="icon-wrench"></i>
                                            <fmt:message key="jnt_portalToolbar.editTab.menu"/>
                                        </a>
                                    </li>

                                    <li ng-show="canBeDeleted">
                                        <a href="#" ng-click="deleteTab('<fmt:message key="jnt_portalToolbar.deleteTab.confirm"/>')">
                                            <i class="icon-trash"></i>
                                            <fmt:message key="jnt_portalToolbar.deleteTab.menu"/>
                                        </a>
                                    </li>

                                    <li>
                                        <a href="#widgetsModal" data-toggle="modal">
                                            <i class="icon-th-large"></i>
                                            <fmt:message key="jnt_portalToolbar.addWidget.menu"/>
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${portalIsEditable}">
                                    <li>
                                        <a href="#" ng-click="${portalIsLocked ? 'unlock()' : 'lock()'}">
                                            <i class="icon-lock"></i>
                                            <fmt:message key="jnt_portalToolbar.${portalIsLocked ? 'unlock' : 'lock'}.menu"/>
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${portalIsModel and portalIsEnabled}">
                                    <c:set var="userPortal" value="${portal:userPortalByModel(portalContext.identifier, currentNode.session)}"/>
                                    <c:choose>
                                        <c:when test="${portalIsCustomizable && userPortal == null}">
                                            <li>
                                                <a ng-click="copyModel()" data-toggle="tooltip" href="#" title="<fmt:message key="jnt_portalToolbar.customize.tooltip"/>" data-placement="left">
                                                    <i class="icon-edit"></i>
                                                    <fmt:message key="jnt_portalToolbar.customize"/>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:when test="${portalIsCustomizable && userPortal != null}">
                                            <li>
                                                <a href="<c:url value="${url.baseLive}${userPortal.path}"/>">
                                                    <i class="icon-share-alt"></i>
                                                    <fmt:message key="jnt_portalToolbar.goToMyPortal"/>
                                                </a>
                                            </li>
                                        </c:when>
                                    </c:choose>
                                </c:if>
                            <c:if test="${!portalIsModel and portalIsEditable and portalIsEnabled}">
                                <li ng-show="isModelExist()">
                                    <a ng-click="resetPortal('<fmt:message key="jnt_portalToolbar.reset.confirm"/>')"
                                       data-toggle="tooltip" href="#"
                                       title="<fmt:message key="jnt_portalToolbar.reset.tooltip"/>"
                                       data-placement="left">
                                        <i class="icon-refresh"></i>
                                        <fmt:message key="jnt_portalToolbar.reset"/>
                                    </a>
                                </li>
                            </c:if>

                            <li class="divider"></li>
                            <c:if test="${jcr:hasPermission(siteNode, 'siteAdminPortalFactory')}">
                                <li>
                                    <a href="<c:url value='${url.baseEdit}${siteNode.path}.portal-factory.html'/>">
                                        <i class="icon-th-list"></i>
                                        <fmt:message key="jnt_portalToolbar.login.portalFactory"/>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
            </li>
        </ul>
    </div>

    <c:if test="${portalIsEditable && !portalIsLocked}">
        <script type="text/ng-template" id="tabFormTemplate">
            <form class="form-horizontal">
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.name"/>:&nbsp; </label><input type="text" ng-model="form.name" required>
                </div>
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.template"/>:&nbsp; </label>
                    <select ng-model='form.template' required ng-options='option.key as option.name for option in form.allowedTemplates'></select>
                </div>
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.widgetsSkin"/>:&nbsp; </label>
                    <select ng-model='form.widgetSkin' required ng-options='option.key as option.name for option in form.allowedWidgetsSkins'></select>
                </div>
                <c:if test="${!portalIsModel}">
                    <div class="control-group">
                        <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.accessibility"/>:&nbsp; </label>
                        <select ng-model='form.accessibility'>
                            <option value="me"><fmt:message key="jnt_portalToolbar.tabForm.accessibility.me"/></option>
                            <option value="users"><fmt:message key="jnt_portalToolbar.tabForm.accessibility.users"/></option>
                            <option value="all"><fmt:message key="jnt_portalToolbar.tabForm.accessibility.all"/></option>
                        </select>
                    </div>
                </c:if>
            </form>
        </script>

        <div id="widgetsModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="widgetModalLabel" ng-controller="widgetsCtrl"
             ng-init="init('widgetsModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="widgetModalLabel"><fmt:message key="jnt_portalToolbar.addTab.menu"/></h3>
            </div>
            <div class="modal-body">
                <form class="form-inline" role="form" name="widgetForm">
                    <div class="form-group row-fluid">
                        <div class="span4">
                            <label for="widget_desiredName"><fmt:message key="jnt_portalToolbar.addWidgetForm.name"/>:</label>
                        </div>
                        <input id="widget_desiredName" class="span8 right" ng-model="desiredName" type="text">
                    </div>

                    <div class="form-group row-fluid">

                        <div class="span4">
                            <label><fmt:message key="jnt_portalToolbar.addWidgetForm.type"/>:</label>
                        </div>
                        <input class="span5 right" ng-model="query" type="text" placeholder="Search...">
                        <input type="hidden" ng-model="desiredWidget" required/>
                    </div>

                    <table class="table table-bordered widgets-table">
                        <tbody>
                            <tr ng-repeat="widget in widgets | filter: search" ng-class="desiredWidget.name == widget.name ? 'active' : ''">
                                <td colspan="2" ng-click="selectWidget(widget)">{{widget.displayableName}}</td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-disabled="widgetForm.$invalid" ng-click="addWidget()"><fmt:message key="add"/></button>
            </div>
        </div>

        <div id="editTabModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="editTabModalLabel" ng-controller="tabCtrl" ng-init="init('edit', 'editTabModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="editTabModalLabel"><fmt:message key="jnt_portalToolbar.editTab"><fmt:param value="{{form.name}}"/></fmt:message></h3>
            </div>
            <div class="modal-body">
                <div>
                    <div ng-include src="'tabFormTemplate'">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-click="submit(false)"><fmt:message key="save"/></button>
            </div>
        </div>

        <div id="newTabModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="newTabModalLabel" ng-controller="tabCtrl" ng-init="init('new', 'newTabModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="newTabModalLabel"><fmt:message key="jnt_portalToolbar.addTab.menu"/></h3>
            </div>
            <div class="modal-body">
                <div>
                    <div ng-include src="'tabFormTemplate'">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-click="submit(true)"><fmt:message key="add"/></button>
            </div>
        </div>

        <div id="newWidgets" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="newWidgetsModalLabel" ng-controller="newWidgetsCtrl" ng-init="init('newWidgets')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="ok()">×</button>
                <h3 id="newWidgetsModalLabel"><fmt:message key="jnt_portalToolbar.portalNotification"/></h3>
            </div>
            <div class="modal-body">
                <div>
                    <p>
                        <fmt:message key="jnt_portalToolbar.newWidgetsAvailable"/>
                    </p>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="ok()">Ok</button>
            </div>
        </div>
    </c:if>
</div>

<script type="text/javascript">
    angular.bootstrap(document.getElementById("portal_toolbar"),['portalToolbar']);
</script>