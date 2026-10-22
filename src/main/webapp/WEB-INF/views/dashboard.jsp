<% request.setAttribute("pageTitle", "My Dashboard"); request.setAttribute("activeNav", "dashboard"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="container-xl py-4">
  <div class="row g-4">
    <aside class="col-lg-3 no-print">
      <div class="k-card p-3 position-sticky" style="top:90px">
        <div class="d-flex align-items-center gap-2 mb-3"><span class="avatar"><c:out value="${fn:substring(student.fullName,0,1)}"/></span><div><strong><c:out value="${student.fullName}"/></strong><div class="small text-muted"><c:out value="${student.district}"/></div></div></div>
        <nav class="side-menu">
          <a class="active" href="${ctx}/student/dashboard"><i class="fa-solid fa-gauge"></i><fmt:message key="nav.dashboard"/></a>
          <a href="${ctx}/courses"><i class="fa-solid fa-book-open"></i><fmt:message key="nav.courses"/></a>
          <a href="${ctx}/exams"><i class="fa-solid fa-landmark"></i><fmt:message key="nav.exams"/></a>
          <a href="${ctx}/roadmap?auto=1"><i class="fa-solid fa-route"></i><fmt:message key="nav.roadmap"/></a>
          <a href="${ctx}/student/saved"><i class="fa-solid fa-bookmark"></i>Saved items</a>
          <a href="${ctx}/student/profile"><i class="fa-solid fa-user-pen"></i>My profile</a>
          <a href="${ctx}/libraries"><i class="fa-solid fa-building-columns"></i><fmt:message key="nav.libraries"/></a>
          <a href="${ctx}/logout"><i class="fa-solid fa-right-from-bracket"></i><fmt:message key="nav.logout"/></a>
        </nav>
      </div>
    </aside>
    <div class="col-lg-9">
      <div class="profile-banner mb-4">
        <h1><fmt:message key="dash.welcome"/>, <c:out value="${fn:substringBefore(student.fullName, ' ')}"/> &#128075;</h1>
        <div class="opacity-75 mb-2"><fmt:message key="dash.journey"/></div>
        <span class="chipw"><i class="fa-solid fa-school me-1"></i>12th Group: <c:out value="${student.group12}"/></span>
        <span class="chipw"><i class="fa-solid fa-percent me-1"></i>Marks: <c:out value="${student.marks}"/>%</span>
        <span class="chipw"><i class="fa-solid fa-location-dot me-1"></i>District: <c:out value="${student.district}"/></span>
        <a class="chipw text-white text-decoration-none" href="${ctx}/student/profile"><i class="fa-solid fa-pen me-1"></i>Edit</a>
      </div>
      <div class="row g-3 mb-4">
        <div class="col-6 col-md-3"><div class="k-card stat"><div class="ico"><i class="fa-solid fa-book-open"></i></div><div><div class="num">${fn:length(rec.courses)}</div><div class="lbl">Recommended Courses</div></div></div></div>
        <div class="col-6 col-md-3"><div class="k-card stat green"><div class="ico"><i class="fa-solid fa-landmark"></i></div><div><div class="num">${fn:length(rec.eligibleExams)}</div><div class="lbl">Eligible Govt Exams</div></div></div></div>
        <div class="col-6 col-md-3"><div class="k-card stat gold"><div class="ico"><i class="fa-solid fa-bookmark"></i></div><div><div class="num">${fn:length(savedCourses)}</div><div class="lbl">Saved Courses</div></div></div></div>
        <div class="col-6 col-md-3"><div class="k-card stat"><div class="ico"><i class="fa-solid fa-calendar-days"></i></div><div><div class="num">${upcomingCount}</div><div class="lbl">Upcoming Exams</div></div></div></div>
      </div>

      <div class="d-flex justify-content-between align-items-center mb-2"><h2 class="h4 mb-0"><fmt:message key="dash.recommended"/></h2><a href="${ctx}/roadmap?auto=1" class="small">Full roadmap &rarr;</a></div>
      <c:choose><c:when test="${empty rec.courses}"><div class="k-card empty-state mb-4"><i class="fa-regular fa-lightbulb"></i><p>No matches yet. <a href="${ctx}/student/profile">Add interests</a> to get recommendations.</p></div></c:when>
      <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 mb-4"><c:forEach items="${rec.courses}" var="sc" end="3"><div class="col"><k:courseCard course="${sc.course}" reason="${sc.reason}" fit="${sc.fit}" saved="${courseSaved.contains(sc.course.id)}"/></div></c:forEach></div></c:otherwise></c:choose>

      <div class="row g-4">
        <div class="col-md-7">
          <h2 class="h4"><fmt:message key="dash.eligible"/></h2>
          <div class="k-card table-card"><ul class="list-group list-group-flush">
            <c:forEach items="${rec.eligibleExams}" var="e" end="4"><li class="list-group-item d-flex justify-content-between align-items-center gap-2"><div><a class="fw-semibold text-decoration-none" href="${ctx}/exam?id=${e.id}"><c:out value="${e.name}"/></a><div class="small text-muted"><c:out value="${e.department}"/></div></div><c:if test="${e.demo}"><span class="demo-pill">DEMO</span></c:if></li></c:forEach>
            <c:if test="${empty rec.eligibleExams}"><li class="list-group-item text-muted">No eligible exams found.</li></c:if></ul></div>
          <h2 class="h4 mt-4"><fmt:message key="dash.upcoming"/></h2>
          <div class="k-card table-card"><ul class="list-group list-group-flush">
            <c:forEach items="${upcoming}" var="d"><li class="list-group-item d-flex justify-content-between"><span><a class="text-decoration-none" href="${ctx}/exam?id=${d.examId}"><c:out value="${d.examName}"/></a><br><small class="text-muted"><c:out value="${d.eventName}"/></small></span><strong class="text-nowrap"><fmt:formatDate value="${d.eventDate}" pattern="dd-MM-yyyy"/></strong></li></c:forEach>
            <c:if test="${empty upcoming}"><li class="list-group-item text-muted">No upcoming dates.</li></c:if></ul></div>
        </div>
        <div class="col-md-5">
          <h2 class="h4"><fmt:message key="dash.roadmap"/></h2>
          <div class="k-card p-3">
            <c:choose><c:when test="${empty latestRoadmap}"><p class="text-muted small mb-2">You have not saved a roadmap yet.</p><a class="btn btn-sm btn-primary" href="${ctx}/roadmap?auto=1">Build my roadmap</a></c:when>
            <c:otherwise><div class="small text-muted">Latest: <fmt:formatDate value="${latestRoadmap.createdAt}" pattern="dd-MM-yyyy"/></div>
              <ol class="small ps-3 my-2"><c:forEach items="${fn:split(latestRoadmap.roadmapSteps, '|')}" var="st"><li><c:out value="${fn:substringBefore(st, '::')}"/></li></c:forEach></ol>
              <a class="btn btn-sm btn-outline-primary" href="${ctx}/student/saved">View / print</a></c:otherwise></c:choose></div>
          <h2 class="h4 mt-4"><fmt:message key="dash.saved"/></h2>
          <div class="k-card p-3"><c:forEach items="${savedCourses}" var="c" end="3"><div class="small mb-1"><i class="fa-solid fa-bookmark text-warning me-1"></i><a href="${ctx}/course?id=${c.id}"><c:out value="${c.name}"/></a></div></c:forEach>
            <c:forEach items="${savedExams}" var="e" end="2"><div class="small mb-1"><i class="fa-solid fa-landmark text-success me-1"></i><a href="${ctx}/exam?id=${e.id}"><c:out value="${e.name}"/></a></div></c:forEach>
            <c:if test="${empty savedCourses and empty savedExams}"><span class="small text-muted">Nothing saved yet.</span></c:if></div>
          <h2 class="h4 mt-4"><fmt:message key="dash.notifications"/></h2>
          <div class="k-card p-3"><c:forEach items="${notifications}" var="n"><div class="mb-2"><div class="fw-semibold small"><i class="fa-solid fa-bell text-warning me-1"></i><c:out value="${n.title}"/> <c:if test="${n.demo}"><span class="demo-pill">DEMO</span></c:if></div><div class="small text-muted"><c:out value="${n.message}"/></div></div></c:forEach>
            <c:if test="${empty notifications}"><span class="small text-muted">No notifications.</span></c:if></div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
