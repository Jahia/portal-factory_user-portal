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
<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js" />
<template:addResources type="javascript" resources="angular.min.js" />
<template:addResources type="javascript" resources="bootstrap-alert.js"/>
<template:addResources type="javascript" resources="bootstrap-dropdown.js"/>
<template:addResources type="javascript" resources="bootstrap-modal.js"/>
<template:addResources type="javascript" resources="bootstrap-transition.js"/>
<template:addResources type="javascript" resources="bootstrap-tooltip.js" />
<template:addResources type="javascript" resources="bootstrap-collapse.js" />
<template:addResources type="javascript" resources="app/portalToolbar.js" />
<template:addResources type="css" resources="portal-toolbar.css"/>
<c:set var="siteNode" value="${renderContext.mainResource.node.resolveSite}"/>

<div id="portal_toolbar" class="portal_toolbar">
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
                <c:if test="${! renderContext.editMode}">
                    <c:if test="${! renderContext.loggedIn}">
                        <div class="login"><a class="btn btn-primary" href="#loginForm" role="button" data-toggle="modal"><i
                                class="icon-user icon-white"></i>&nbsp;<fmt:message
                                key="jnt_portalToolbar.login.title"/></a>
                        </div>

                        <div id="loginForm" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                             aria-hidden="true">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                                <h3 id="myModalLabel"><fmt:message key="jnt_portalToolbar.login.title"/></h3>
                            </div>
                            <div class="modal-body">
                                <ui:loginArea>
                                    <c:if test="${not empty param['loginError']}">
                                        <div class="alert alert-error"><fmt:message
                                                key="${param['loginError'] == 'account_locked' ? 'message.accountLocked' : 'message.invalidUsernamePassword'}"/></div>
                                    </c:if>

                                    <p>
                                        <label for="username" class="control-label"><fmt:message
                                                key="jnt_portalToolbar.login.username"/></label>

                                        <input type="text" value="" id="username" name="username"
                                               class="input-icon input-icon-first-name"
                                               placeholder="<fmt:message key="jnt_portalToolbar.login.username"/>">
                                    </p>

                                    <p>
                                        <label for="password" class="control-label"><fmt:message
                                                key="jnt_portalToolbar.login.password"/></label>
                                        <input type="password" name="password" id="password"
                                               class="input-icon input-icon-password"
                                               placeholder="<fmt:message key="jnt_portalToolbar.login.password"/>">
                                    </p>

                                    <p>
                                        <label for="useCookie" class="checkbox">
                                            <input type="checkbox" id="useCookie" name="useCookie"/>
                                            <fmt:message key="jnt_portalToolbar.login.rememberMe"/>
                                        </label>
                                    </p>

                                    <p class="text-right">
                                        <button class="btn btn-primary"><i class="icon-ok icon-white"></i> <fmt:message
                                                key='jnt_portalToolbar.login.title'/>
                                        </button>
                                    </p>

                                </ui:loginArea>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true"><i
                                        class="icon-remove icon-white"></i> Close
                                </button>
                            </div>
                        </div>

                        <script type="text/javascript">
                            $(document).ready(function () {
                                <c:set var="modalOption" value="${empty param['loginError'] ? 'hide' : 'show'}"/>
                                $('#loginForm').modal('${modalOption}');
                                $('#loginForm').appendTo("body");
                            })
                        </script>
                    </c:if>
                </c:if>
                <c:if test="${renderContext.loggedIn}">
                    <div class="user-box dropdown">

                        <jcr:node var="userNode" path="${currentUser.localPath}"/>
                        <jcr:nodeProperty var="picture" node="${userNode}" name="j:picture"/>
                        <c:set var="firstname" value="${userNode.properties['j:firstName'].string}"/>
                        <c:set var="lastname" value="${userNode.properties['j:lastName'].string}"/>

                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            <c:if test="${not empty picture}">
                                <template:addCacheDependency flushOnPathMatchingRegexp="${userNode.path}/files/profile/.*"/>
                                <img class='user-photo' src="${picture.node.thumbnailUrls['avatar_120']}"
                                     alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="30" height="30"/>
                            </c:if>
                            <c:if test="${empty picture}">
                                <img class='user-photo' src="<c:url value="${url.currentModule}/images/user.png"/>"
                                     alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="30"
                                     height="30"/>
                            </c:if>
                                ${fn:escapeXml(empty firstname and empty lastname ? userNode.name : firstname)}&nbsp;${fn:escapeXml(lastname)}
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
                                        <a href="#" ng-click="deleteTab()">
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
                                            <a ng-click="copyModel()" class="toolbar-tooltip" href="#" title="<fmt:message key="jnt_portalToolbar.customize.tooltip"/>" data-placement="left">
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

                            <li class="divider"></li>
                            <li>
                                <a href="<c:url value='${url.myProfile}'/>">
                                    <i class="icon-user"></i>
                                    <fmt:message key="jnt_portalToolbar.login.profile"/>
                                </a>
                            </li>
                            <c:if test="${portalIsModel && jcr:hasPermission(siteNode, 'siteAdminPortalFactory')}">
                                <li>
                                    <a href="<c:url value='${url.baseEdit}${siteNode.path}.portal-factory.html'/>">
                                        <i class="icon-th-list"></i>
                                        <fmt:message key="jnt_portalToolbar.login.portalFactory"/>
                                    </a>
                                </li>
                            </c:if>

                            <li class="divider"></li>

                            <li>
                                <a href="<c:url value='${url.logout}'/>">
                                    <i class="icon-off"></i>
                                    <fmt:message key="jnt_portalToolbar.login.logout"/>
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:if>
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