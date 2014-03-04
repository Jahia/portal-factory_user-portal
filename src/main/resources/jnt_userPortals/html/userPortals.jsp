<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="portal" uri="http://www.jahia.org/tags/portalLib" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="portalNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="user-portals.css"/>

<jcr:node path="${renderContext.user.localPath}" var="user" />
<template:addCacheDependency path="${user.path}/portals/${renderContext.site.siteKey}"/>
<template:addCacheDependency path="${renderContext.site.path}/portals"/>

<div>
    <h3><fmt:message key="userPortals.myPortals"/>:</h3>
    <ul class="nav nav-list userPortals">
        <c:forEach items="${portal:userPortalsBySite(renderContext.site.siteKey)}" var="portalNode">
            <li>
                <a href="<c:url value="${url.baseLive}${portalNode.path}"/>">${portalNode.displayableName}</a>
            </li>
        </c:forEach>
    </ul>
</div>
