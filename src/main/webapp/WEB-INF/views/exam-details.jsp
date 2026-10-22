<% request.setAttribute("pageTitle", ((com.kalvi.model.GovernmentExam) request.getAttribute("exam")).getName()); request.setAttribute("activeNav", "exams"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="${exam.name}" breadcrumbParent="Government Exams" parentUrl="/exams" subtitle="${exam.department}"/>
<div class="container section pt-4">
  <div class="mb-3"><k:sourceBox exam="${exam}"/></div>
  <div class="row g-4">
    <div class="col-lg-8">
      <div class="k-card detail-block mb-3"><h2>Eligibility</h2><dl class="mb-0">
        <dt>Educational qualification</dt><dd><span class="tag"><c:out value="${exam.qualification}"/></span> <c:out value="${exam.eligibility}"/></dd>
        <dt>Age limit</dt><dd><c:out value="${exam.ageLimit}"/> <c:if test="${exam.minAge > 0}"><span class="text-muted small">(min <c:out value="${exam.minAge}"/><c:if test="${exam.maxAge > 0}">, max <c:out value="${exam.maxAge}"/></c:if>)</span></c:if></dd></dl></div>
      <div class="k-card detail-block mb-3"><h2>Application &amp; registration</h2><dl class="mb-0">
        <dt>Application process</dt><dd><c:out value="${exam.applicationProcess}"/></dd>
        <dt>Registration information</dt><dd><c:out value="${exam.registrationInfo}"/></dd></dl></div>
      <div class="k-card detail-block mb-3"><h2>Exam pattern &amp; syllabus</h2><dl class="mb-0">
        <dt>Exam pattern</dt><dd><c:out value="${exam.examPattern}"/></dd>
        <dt>Syllabus</dt><dd><c:out value="${exam.syllabus}"/></dd>
        <dt>Selection process</dt><dd><c:out value="${exam.selectionProcess}"/></dd></dl></div>
      <div class="k-card detail-block mb-3"><h2>Examination instructions</h2><p class="mb-0"><c:out value="${exam.instructions}"/></p></div>
      <div class="k-card detail-block"><h2>Examination centers</h2>
        <c:choose><c:when test="${empty centers}"><p class="text-muted mb-0">Centers will be listed after the official notification.</p></c:when>
        <c:otherwise><div class="table-responsive"><table class="table table-sm mb-0"><thead><tr><th>District</th><th>Center</th><th>Address</th></tr></thead><tbody>
          <c:forEach items="${centers}" var="c"><tr><td><c:out value="${c.district}"/></td><td><c:out value="${c.centerName}"/></td><td><c:out value="${c.address}"/></td></tr></c:forEach></tbody></table></div></c:otherwise></c:choose></div>
    </div>
    <div class="col-lg-4">
      <div class="k-card detail-block mb-3"><h2><i class="fa-solid fa-calendar-days text-warning me-1"></i>Important dates</h2>
        <c:choose><c:when test="${empty dates}"><p class="text-muted mb-0">No dates published yet.</p></c:when>
        <c:otherwise><ul class="list-unstyled mb-0"><c:forEach items="${dates}" var="d"><li class="py-2 border-bottom"><strong><fmt:formatDate value="${d.eventDate}" pattern="dd-MM-yyyy"/></strong>
          <c:choose><c:when test="${d.official}"><span class="verified-pill">Official</span></c:when><c:otherwise><span class="demo-pill">DEMO</span></c:otherwise></c:choose><br><c:out value="${d.eventName}"/></li></c:forEach></ul></c:otherwise></c:choose></div>
      <div class="k-card p-3 no-print">
        <c:if test="${not empty exam.officialUrl}"><a class="btn btn-primary w-100 mb-2" href="<c:out value='${exam.officialUrl}'/>" target="_blank" rel="noopener noreferrer"><i class="fa-solid fa-globe me-1"></i>Official Website</a></c:if>
        <c:choose>
          <c:when test="${not empty sessionScope.user and sessionScope.user.role == 'STUDENT'}">
            <c:set var="isSaved" value="${not empty savedIds and savedIds.contains(exam.id)}"/>
            <form action="${ctx}/student/save-exam" method="post"><input type="hidden" name="examId" value="${exam.id}"><button class="btn ${isSaved ? 'btn-success' : 'btn-outline-primary'} w-100" type="submit"><i class="fa-bookmark me-1 ${isSaved ? 'fa-solid' : 'fa-regular'}"></i>${isSaved ? 'Saved - click to remove' : 'Save this exam'}</button></form>
          </c:when>
          <c:otherwise><a class="btn btn-outline-primary w-100" href="${ctx}/login?msg=login">Login to save</a></c:otherwise>
        </c:choose>
        <button class="btn btn-outline-secondary w-100 mt-2" data-print type="button"><i class="fa-solid fa-print me-1"></i>Print</button>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
