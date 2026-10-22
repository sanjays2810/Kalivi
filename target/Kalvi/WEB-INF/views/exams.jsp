<% request.setAttribute("pageTitle", "Government Exams"); request.setAttribute("activeNav", "exams"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Government Exams" subtitle="TNPSC, TRB, TET and other opportunities - check eligibility by qualification and age."/>
<div class="container section pt-4">
  <div class="alert alert-warning small"><i class="fa-solid fa-triangle-exclamation me-1"></i><strong>Demo data:</strong> entries marked <span class="demo-pill">DEMO DATA</span> are samples, not official information. Always verify on the official website before applying.</div>
  <form class="k-card p-3 mb-4 no-print" method="get" action="${ctx}/exams">
    <div class="row g-2 align-items-end">
      <div class="col-lg-3"><label class="form-label small mb-1" for="q">Search Government Exams</label><input class="form-control" id="q" name="q" placeholder="e.g. TNPSC, teacher" value="<c:out value='${param.q}'/>"></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">My qualification</label><select class="form-select" name="qualification"><option value="">Any</option>
        <c:forEach items="${applicationScope.qualifications}" var="q"><option ${param.qualification == q ? 'selected' : ''}>${q}</option></c:forEach></select></div>
      <div class="col-6 col-lg-1"><label class="form-label small mb-1">Age</label><input class="form-control" type="number" min="14" max="60" name="age" value="<c:out value='${param.age}'/>"></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">Category</label><select class="form-select" name="category"><option value="">All</option>
        <c:forEach items="${categories}" var="c"><option ${param.category == c ? 'selected' : ''}><c:out value="${c}"/></option></c:forEach></select></div>
      <div class="col-6 col-lg-2"><label class="form-label small mb-1">Department</label><select class="form-select" name="department"><option value="">All</option>
        <c:forEach items="${departments}" var="d"><option ${param.department == d ? 'selected' : ''}><c:out value="${d}"/></option></c:forEach></select></div>
      <div class="col-lg-2 d-flex gap-2"><button class="btn btn-primary" type="submit"><i class="fa-solid fa-magnifying-glass me-1"></i>Search</button><a class="btn btn-outline-secondary" href="${ctx}/exams">Reset</a></div>
    </div>
  </form>
  <div class="row g-4">
    <div class="col-lg-9">
      <p class="text-muted small"><strong>${fn:length(exams)}</strong> exam(s) found</p>
      <c:choose>
        <c:when test="${empty exams}"><div class="k-card empty-state"><i class="fa-regular fa-folder-open"></i><h2 class="h5">No exams match these filters</h2><a class="btn btn-primary" href="${ctx}/exams">Show all exams</a></div></c:when>
        <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2">
          <c:forEach items="${exams}" var="e"><div class="col"><k:examCard exam="${e}" saved="${not empty savedIds and savedIds.contains(e.id)}"/></div></c:forEach></div></c:otherwise>
      </c:choose>
    </div>
    <div class="col-lg-3" id="upcoming">
      <div class="k-card p-3"><h2 class="h6"><i class="fa-solid fa-calendar-days text-warning me-1"></i>Upcoming dates</h2>
        <c:forEach items="${upcoming}" var="d">
          <div class="border-bottom py-2 small"><strong><fmt:formatDate value="${d.eventDate}" pattern="dd-MM-yyyy"/></strong>
            <c:if test="${not d.official}"> <span class="demo-pill">DEMO</span></c:if><br><a href="${ctx}/exam?id=${d.examId}"><c:out value="${d.examName}"/></a><br><span class="text-muted"><c:out value="${d.eventName}"/></span></div>
        </c:forEach>
        <c:if test="${empty upcoming}"><p class="small text-muted mb-0">No upcoming dates published.</p></c:if>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
