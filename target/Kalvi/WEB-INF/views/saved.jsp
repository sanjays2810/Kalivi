<% request.setAttribute("pageTitle", "Saved Items"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Saved Items" breadcrumbParent="Dashboard" parentUrl="/student/dashboard" subtitle="Your saved courses, exams and career roadmaps."/>
<div class="container section pt-4">
  <h2 class="h4">Career roadmaps</h2>
  <c:choose><c:when test="${empty roadmaps}"><div class="k-card empty-state mb-4"><i class="fa-solid fa-route"></i><p>No saved roadmaps. <a href="${ctx}/roadmap?auto=1">Build one now</a>.</p></div></c:when>
  <c:otherwise><div class="accordion mb-4" id="rm"><c:forEach items="${roadmaps}" var="r" varStatus="s"><div class="accordion-item">
    <h2 class="accordion-header"><button class="accordion-button ${s.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#rm${r.id}"><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/> &nbsp;&mdash;&nbsp; <strong><c:out value="${r.topCourse}"/></strong></button></h2>
    <div id="rm${r.id}" class="accordion-collapse collapse ${s.first ? 'show' : ''}" data-bs-parent="#rm"><div class="accordion-body">
      <ol class="timeline"><c:forEach items="${fn:split(r.roadmapSteps, '|')}" var="st" varStatus="n"><li><span class="dot"><i class="fa-solid fa-flag-checkered"></i></span><div class="step-no">Step ${n.count}</div><h3><c:out value="${fn:substringBefore(st, '::')}"/></h3><p><c:out value="${fn:substringAfter(st, '::')}"/></p></li></c:forEach></ol>
      <div class="d-flex gap-2 no-print"><button class="btn btn-sm btn-outline-primary" data-print type="button"><i class="fa-solid fa-print me-1"></i>Print</button>
        <form method="post" action="${ctx}/student/saved" data-confirm="Delete this roadmap?"><input type="hidden" name="id" value="${r.id}"><button class="btn btn-sm btn-outline-danger">Delete</button></form></div>
    </div></div></div></c:forEach></div></c:otherwise></c:choose>

  <h2 class="h4">Saved courses</h2>
  <c:choose><c:when test="${empty savedCourses}"><div class="k-card empty-state mb-4"><i class="fa-regular fa-bookmark"></i><p>No saved courses. <a href="${ctx}/courses">Explore courses</a>.</p></div></c:when>
  <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3 mb-4"><c:forEach items="${savedCourses}" var="c"><div class="col"><k:courseCard course="${c}" saved="true"/></div></c:forEach></div></c:otherwise></c:choose>

  <h2 class="h4">Saved exams</h2>
  <c:choose><c:when test="${empty savedExams}"><div class="k-card empty-state"><i class="fa-regular fa-bookmark"></i><p>No saved exams. <a href="${ctx}/exams">Explore government exams</a>.</p></div></c:when>
  <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3"><c:forEach items="${savedExams}" var="e"><div class="col"><k:examCard exam="${e}" saved="true"/></div></c:forEach></div></c:otherwise></c:choose>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
