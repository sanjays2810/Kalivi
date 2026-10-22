<% request.setAttribute("pageTitle", "Explore Courses"); request.setAttribute("activeNav", "courses"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Explore Courses" subtitle="Find suitable courses after 12th - filter by group, duration, career field and interest."/>
<div class="container section pt-4">
  <form class="k-card p-3 mb-4 no-print" method="get" action="${ctx}/courses">
    <div class="row g-2 align-items-end">
      <div class="col-lg-4"><label class="form-label small mb-1" for="q">Search</label><input class="form-control" id="q" name="q" placeholder="Search Course..." value="<c:out value='${param.q}'/>"></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">Category</label><select class="form-select" name="category"><option value="">All</option>
        <c:forEach items="${categories}" var="cat"><option value="${cat.id}" ${param.category == cat.id ? 'selected' : ''}><c:out value="${cat.name}"/></option></c:forEach></select></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">12th group</label><select class="form-select" name="group"><option value="">Any</option>
        <c:forEach items="${applicationScope.groups}" var="g"><option ${param.group == g ? 'selected' : ''}>${g}</option></c:forEach></select></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">Duration</label><select class="form-select" name="duration"><option value="">Any</option>
        <c:forEach items="${durations}" var="d"><option ${param.duration == d ? 'selected' : ''}><c:out value="${d}"/></option></c:forEach></select></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">Career field</label><select class="form-select" name="field"><option value="">Any</option>
        <c:forEach items="${fields}" var="f"><option ${param.field == f ? 'selected' : ''}><c:out value="${f}"/></option></c:forEach></select></div>
      <div class="col-lg-4"><label class="form-label small mb-1">Interest</label><select class="form-select" name="interest"><option value="">Any</option>
        <c:forEach items="${applicationScope.interestOptions}" var="i"><option ${param.interest == i ? 'selected' : ''}><c:out value="${i}"/></option></c:forEach></select></div>
      <div class="col-lg-8 d-flex gap-2"><button class="btn btn-primary" type="submit"><i class="fa-solid fa-magnifying-glass me-1"></i>Search</button><a class="btn btn-outline-secondary" href="${ctx}/courses">Reset</a></div>
    </div>
  </form>
  <p class="text-muted small"><strong>${total}</strong> course(s) found</p>
  <c:choose>
    <c:when test="${empty courses}"><div class="k-card empty-state"><i class="fa-regular fa-face-frown"></i><h2 class="h5">No courses match your search</h2><p>Try removing some filters.</p><a class="btn btn-primary" href="${ctx}/courses">Show all courses</a></div></c:when>
    <c:otherwise>
      <div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3">
        <c:forEach items="${courses}" var="c"><div class="col"><k:courseCard course="${c}" saved="${not empty savedIds and savedIds.contains(c.id)}"/></div></c:forEach>
      </div>
      <c:if test="${pages > 1}">
        <nav class="mt-4 no-print" aria-label="Pages"><ul class="pagination justify-content-center">
          <li class="page-item ${page == 1 ? 'disabled' : ''}"><a class="page-link" href="${ctx}/courses?page=${page - 1}${qs}">&laquo;</a></li>
          <c:forEach begin="1" end="${pages}" var="p"><li class="page-item ${p == page ? 'active' : ''}"><a class="page-link" href="${ctx}/courses?page=${p}${qs}">${p}</a></li></c:forEach>
          <li class="page-item ${page == pages ? 'disabled' : ''}"><a class="page-link" href="${ctx}/courses?page=${page + 1}${qs}">&raquo;</a></li>
        </ul></nav>
      </c:if>
    </c:otherwise>
  </c:choose>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
