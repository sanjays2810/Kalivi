<% request.setAttribute("pageTitle", "Reports"); request.setAttribute("activeAdmin", "reports"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<div class="d-flex justify-content-between mb-3 no-print"><p class="text-muted mb-0">Summary of platform data.</p><button class="btn btn-outline-primary btn-sm" data-print type="button"><i class="fa-solid fa-print me-1"></i>Print report</button></div>
<div class="row g-3">
  <div class="col-lg-6"><div class="k-card table-card"><table class="table"><thead><tr><th>Students by 12th group</th><th class="text-end">Count</th></tr></thead><tbody>
    <c:forEach items="${byGroup}" var="e"><tr><td><c:out value="${e.key}"/></td><td class="text-end">${e.value}</td></tr></c:forEach><c:if test="${empty byGroup}"><tr><td colspan="2" class="text-muted">No data</td></tr></c:if></tbody></table></div></div>
  <div class="col-lg-6"><div class="k-card table-card"><table class="table"><thead><tr><th>Students by district</th><th class="text-end">Count</th></tr></thead><tbody>
    <c:forEach items="${byDistrict}" var="e"><tr><td><c:out value="${e.key}"/></td><td class="text-end">${e.value}</td></tr></c:forEach><c:if test="${empty byDistrict}"><tr><td colspan="2" class="text-muted">No data</td></tr></c:if></tbody></table></div></div>
  <div class="col-lg-6"><div class="k-card table-card"><table class="table"><thead><tr><th>Courses by category</th><th class="text-end">Count</th></tr></thead><tbody>
    <c:forEach items="${byCategory}" var="e"><tr><td><c:out value="${e.key}"/></td><td class="text-end">${e.value}</td></tr></c:forEach></tbody></table></div></div>
  <div class="col-lg-6"><div class="k-card table-card"><table class="table"><thead><tr><th>Exams by category</th><th class="text-end">Count</th></tr></thead><tbody>
    <c:forEach items="${byExamCategory}" var="e"><tr><td><c:out value="${e.key}"/></td><td class="text-end">${e.value}</td></tr></c:forEach></tbody></table></div></div>
</div>
<div class="k-card p-3 mt-3">Totals: <strong>${totalStudents}</strong> students &bull; <strong>${totalCourses}</strong> courses &bull; <strong>${totalExams}</strong> exams &bull; <strong>${totalResources}</strong> resources &bull; <strong>${totalLibraries}</strong> libraries</div>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
