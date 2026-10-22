<%@ tag body-content="empty" pageEncoding="UTF-8" description="Blue page header with breadcrumb" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="subtitle" %>
<%@ attribute name="breadcrumbParent" %>
<%@ attribute name="parentUrl" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="page-head"><div class="container">
  <nav aria-label="breadcrumb"><ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${ctx}/">Home</a></li>
    <c:if test="${not empty breadcrumbParent}"><li class="breadcrumb-item"><a href="${ctx}${parentUrl}"><c:out value="${breadcrumbParent}"/></a></li></c:if>
    <li class="breadcrumb-item active" aria-current="page"><c:out value="${title}"/></li>
  </ol></nav>
  <h1 class="h2"><c:out value="${title}"/></h1>
  <c:if test="${not empty subtitle}"><p><c:out value="${subtitle}"/></p></c:if>
</div></div>
