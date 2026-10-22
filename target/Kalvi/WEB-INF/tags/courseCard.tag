<%@ tag body-content="empty" pageEncoding="UTF-8" description="Course card" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ attribute name="course" type="com.kalvi.model.Course" required="true" %>
<%@ attribute name="saved" type="java.lang.Boolean" %>
<%@ attribute name="reason" %>
<%@ attribute name="fit" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="k-card hoverable course-card">
  <div class="d-flex justify-content-between align-items-start gap-2">
    <span class="tag"><c:out value="${course.categoryName}"/></span>
    <c:if test="${course.demo}"><span class="demo-pill" title="Sample information - verify with the college / official site">DEMO</span></c:if>
  </div>
  <h3 class="mt-2"><a class="text-decoration-none" href="${ctx}/course?id=${course.id}"><c:out value="${course.name}"/></a></h3>
  <div class="meta"><span><i class="fa-regular fa-clock me-1"></i><c:out value="${course.duration}"/></span><span><i class="fa-solid fa-user-graduate me-1"></i><c:out value="${fn:substring(course.eligibility,0,34)}"/></span></div>
  <c:if test="${not empty fit}"><div class="mb-2"><span class="tag ${fn:startsWith(fit,'Stretch') ? 'gold' : 'green'}"><c:out value="${fit}"/></span></div></c:if>
  <div class="small fw-semibold text-muted">Career Scope</div>
  <ul class="career-list small">
    <c:forEach items="${fn:split(course.careerOpportunities, ',')}" var="job" end="2"><li><c:out value="${job}"/></li></c:forEach>
  </ul>
  <c:if test="${not empty reason}"><p class="small text-muted mb-3"><i class="fa-solid fa-lightbulb text-warning me-1"></i>Why: <c:out value="${reason}"/></p></c:if>
  <div class="mt-auto d-flex gap-2 no-print">
    <a class="btn btn-sm btn-primary" href="${ctx}/course?id=${course.id}">View Details</a>
    <c:choose>
      <c:when test="${not empty sessionScope.user and sessionScope.user.role == 'STUDENT'}">
        <form action="${ctx}/student/save-course" method="post" class="d-inline"><input type="hidden" name="courseId" value="${course.id}">
          <button class="btn btn-sm ${saved ? 'btn-success' : 'btn-outline-primary'}" type="submit"><i class="${saved ? 'fa-solid' : 'fa-regular'} fa-bookmark me-1"></i>${saved ? 'Saved' : 'Save'}</button></form>
      </c:when>
      <c:otherwise><a class="btn btn-sm btn-outline-primary" href="${ctx}/login?msg=login"><i class="fa-regular fa-bookmark me-1"></i>Save</a></c:otherwise>
    </c:choose>
  </div>
</div>
