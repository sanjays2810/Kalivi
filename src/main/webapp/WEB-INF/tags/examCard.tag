<%@ tag body-content="empty" pageEncoding="UTF-8" description="Government exam card" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ attribute name="exam" type="com.kalvi.model.GovernmentExam" required="true" %>
<%@ attribute name="saved" type="java.lang.Boolean" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="k-card hoverable course-card">
  <div class="d-flex justify-content-between align-items-start gap-2">
    <span class="tag green"><c:out value="${exam.category}"/></span>
    <c:choose><c:when test="${exam.demo}"><span class="demo-pill">DEMO DATA</span></c:when><c:otherwise><span class="verified-pill"><i class="fa-solid fa-circle-check"></i> Verified</span></c:otherwise></c:choose>
  </div>
  <h3 class="mt-2"><a class="text-decoration-none" href="${ctx}/exam?id=${exam.id}"><c:out value="${exam.name}"/></a></h3>
  <p class="small text-muted mb-2"><c:out value="${exam.department}"/></p>
  <div class="meta"><span><i class="fa-solid fa-graduation-cap me-1"></i>Qualification: <c:out value="${exam.qualification}"/></span>
    <c:if test="${exam.minAge > 0}"><span><i class="fa-solid fa-cake-candles me-1"></i>Age <c:out value="${exam.minAge}"/><c:if test="${exam.maxAge > 0}">&ndash;<c:out value="${exam.maxAge}"/></c:if><c:if test="${exam.maxAge == 0}">+</c:if></span></c:if></div>
  <div class="small text-muted mb-3">Last updated: <fmt:formatDate value="${exam.lastUpdated}" pattern="dd-MM-yyyy"/></div>
  <div class="mt-auto d-flex gap-2 no-print">
    <a class="btn btn-sm btn-primary" href="${ctx}/exam?id=${exam.id}">View Details</a>
    <c:choose>
      <c:when test="${not empty sessionScope.user and sessionScope.user.role == 'STUDENT'}">
        <form action="${ctx}/student/save-exam" method="post" class="d-inline"><input type="hidden" name="examId" value="${exam.id}">
          <button class="btn btn-sm ${saved ? 'btn-success' : 'btn-outline-primary'}" type="submit"><i class="${saved ? 'fa-solid' : 'fa-regular'} fa-bookmark me-1"></i>${saved ? 'Saved' : 'Save'}</button></form>
      </c:when>
      <c:otherwise><a class="btn btn-sm btn-outline-primary" href="${ctx}/login?msg=login"><i class="fa-regular fa-bookmark me-1"></i>Save</a></c:otherwise>
    </c:choose>
  </div>
</div>
