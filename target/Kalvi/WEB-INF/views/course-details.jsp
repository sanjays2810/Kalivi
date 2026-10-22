<% request.setAttribute("pageTitle", ((com.kalvi.model.Course) request.getAttribute("course")).getName()); request.setAttribute("activeNav", "courses"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="${course.name}" breadcrumbParent="Courses" parentUrl="/courses" subtitle="${course.categoryName} • ${course.duration}"/>
<div class="container section pt-4">
  <div class="row g-4">
    <div class="col-lg-8">
      <div class="k-card detail-block mb-3">
        <div class="d-flex justify-content-between"><h2>About this course</h2><c:if test="${course.demo}"><span class="demo-pill align-self-start">DEMO DATA</span></c:if></div>
        <p><c:out value="${course.description}"/></p>
        <dl class="row mb-0">
          <dt class="col-sm-4">Duration</dt><dd class="col-sm-8"><c:out value="${course.duration}"/></dd>
          <dt class="col-sm-4">Eligibility</dt><dd class="col-sm-8"><c:out value="${course.eligibility}"/></dd>
          <dt class="col-sm-4">Required 12th group</dt><dd class="col-sm-8"><c:forEach items="${fn:split(course.requiredGroups, ',')}" var="g"><span class="tag"><c:out value="${g}"/></span></c:forEach></dd>
          <dt class="col-sm-4">Admission requirements</dt><dd class="col-sm-8"><c:out value="${course.admissionRequirements}"/> <c:if test="${course.minMarks > 0}"><br><span class="text-muted small">Approximate marks that usually help: ${course.minMarks}%+</span></c:if></dd>
          <dt class="col-sm-4">Skills required</dt><dd class="col-sm-8"><c:forEach items="${fn:split(course.skills, ',')}" var="s"><span class="tag green"><c:out value="${s}"/></span></c:forEach></dd>
        </dl>
      </div>
      <div class="row g-3">
        <div class="col-md-6"><div class="k-card detail-block h-100"><h2><i class="fa-solid fa-briefcase text-warning me-2"></i>Career opportunities</h2>
          <ul class="career-list mb-0"><c:forEach items="${fn:split(course.careerOpportunities, ',')}" var="x"><li><c:out value="${x}"/></li></c:forEach></ul></div></div>
        <div class="col-md-6"><div class="k-card detail-block h-100"><h2><i class="fa-solid fa-building text-warning me-2"></i>Job opportunities</h2><p class="mb-0"><c:out value="${course.jobOpportunities}"/></p></div></div>
        <div class="col-md-6"><div class="k-card detail-block h-100"><h2><i class="fa-solid fa-book-open-reader text-warning me-2"></i>Higher studies</h2><p class="mb-0"><c:out value="${course.higherStudies}"/></p></div></div>
        <div class="col-md-6"><div class="k-card detail-block h-100"><h2><i class="fa-solid fa-landmark text-warning me-2"></i>Government opportunities</h2><p class="mb-0"><c:out value="${course.governmentOpportunities}"/></p></div></div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="k-card p-3 mb-3 no-print">
        <c:choose>
          <c:when test="${not empty sessionScope.user and sessionScope.user.role == 'STUDENT'}">
            <form action="${ctx}/student/save-course" method="post"><input type="hidden" name="courseId" value="${course.id}">
              <c:set var="isSaved" value="${not empty savedIds and savedIds.contains(course.id)}"/>
              <button class="btn ${isSaved ? 'btn-success' : 'btn-primary'} w-100" type="submit"><i class="fa-bookmark me-1 ${isSaved ? 'fa-solid' : 'fa-regular'}"></i>${isSaved ? 'Saved - click to remove' : 'Save this course'}</button></form>
          </c:when>
          <c:otherwise><a class="btn btn-primary w-100" href="${ctx}/login?msg=login">Login to save this course</a></c:otherwise>
        </c:choose>
        <a class="btn btn-outline-primary w-100 mt-2" href="${ctx}/roadmap"><i class="fa-solid fa-route me-1"></i>Build my roadmap</a>
        <button class="btn btn-outline-secondary w-100 mt-2" data-print type="button"><i class="fa-solid fa-print me-1"></i>Print</button>
      </div>
      <div class="source-box">Course details are guidance only. Confirm cut-offs, fees and dates with the college or the official admission portal.<br><span class="small text-muted">Last updated: <fmt:formatDate value="${course.lastUpdated}" pattern="dd-MM-yyyy"/></span></div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
