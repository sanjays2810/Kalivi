<% request.setAttribute("pageTitle", "Career Roadmap"); request.setAttribute("activeNav", "roadmap"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Career Roadmap" subtitle="Tell us about your 12th results and interests - we build a personalised education and career path."/>
<div class="container section pt-4">
  <c:if test="${not empty errors}"><div class="alert alert-danger"><ul class="mb-0"><c:forEach items="${errors}" var="e"><li><c:out value="${e}"/></li></c:forEach></ul></div></c:if>

  <form class="k-card p-4 mb-4 no-print needs-validation" method="post" action="${ctx}/roadmap" novalidate>
    <div class="d-flex justify-content-between flex-wrap gap-2 mb-3">
      <h2 class="h5 mb-0">Your details</h2>
      <c:if test="${not empty sessionScope.user and sessionScope.user.role == 'STUDENT' and empty result}"><a class="btn btn-sm btn-outline-primary" href="${ctx}/roadmap?auto=1"><i class="fa-solid fa-wand-magic-sparkles me-1"></i>Build from my saved profile</a></c:if>
    </div>
    <div class="row g-3">
      <k:profileFields s="${form}" showDistrict="true"/>
    </div>
    <button class="btn btn-primary mt-4" type="submit"><i class="fa-solid fa-route me-1"></i>Generate my roadmap</button>
  </form>

  <c:if test="${not empty result}">
    <div class="print-only mb-3"><h2>Kalvi Career Roadmap</h2><p>Prepared for: <c:out value="${empty sessionScope.user ? 'Student' : sessionScope.user.fullName}"/> &mdash; 12th <c:out value="${form.group12}"/>, <c:out value="${form.marks}"/>%</p></div>
    <c:if test="${savedMsg}"><div class="alert alert-success no-print"><i class="fa-solid fa-circle-check me-1"></i>Roadmap saved to your account. <a href="${ctx}/student/saved">View saved roadmaps</a></div></c:if>
    <c:if test="${empty sessionScope.user}"><div class="alert alert-info no-print">Want to save this roadmap? <a href="${ctx}/register">Register</a> or <a href="${ctx}/login">login</a>.</div></c:if>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2 class="section-title mb-0">YOUR CAREER ROADMAP</h2>
      <button type="button" class="btn btn-outline-primary no-print" data-print><i class="fa-solid fa-print me-1"></i>Print roadmap</button>
    </div>
    <div class="k-card p-4 mb-4">
      <ol class="timeline">
        <c:forEach items="${result.steps}" var="s" varStatus="st">
          <li><span class="dot"><i class="fa-solid ${s.icon}"></i></span><div class="step-no">Step ${st.count}</div><h3><c:out value="${s.title}"/></h3><p><c:out value="${s.detail}"/></p></li>
        </c:forEach>
      </ol>
    </div>

    <h2 class="h4 mb-3">Recommended courses</h2>
    <c:choose><c:when test="${empty result.courses}"><div class="k-card empty-state"><i class="fa-regular fa-lightbulb"></i><p>No matching course found. Try selecting different interests or <a href="${ctx}/courses">browse all courses</a>.</p></div></c:when>
    <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3">
      <c:forEach items="${result.courses}" var="sc"><div class="col"><k:courseCard course="${sc.course}" reason="${sc.reason}" fit="${sc.fit}" saved="false"/></div></c:forEach></div></c:otherwise></c:choose>

    <h2 class="h4 mt-5 mb-1">Government exams you can consider</h2>
    <p class="text-muted small">Based on your qualification (12th) and age. Sample data - verify on official websites.</p>
    <c:choose><c:when test="${empty result.eligibleExams}"><p class="text-muted">No exam matches your age/qualification right now.</p></c:when>
    <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3"><c:forEach items="${result.eligibleExams}" var="e" end="5"><div class="col"><k:examCard exam="${e}" saved="false"/></div></c:forEach></div></c:otherwise></c:choose>

    <c:if test="${not empty result.futureExams}">
      <h2 class="h4 mt-5 mb-1">After your degree</h2><p class="text-muted small">Exams that require a degree - good long-term goals.</p>
      <div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3"><c:forEach items="${result.futureExams}" var="e"><div class="col"><k:examCard exam="${e}" saved="false"/></div></c:forEach></div>
    </c:if>
  </c:if>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
