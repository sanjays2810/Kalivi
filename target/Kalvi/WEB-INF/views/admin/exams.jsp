<% request.setAttribute("pageTitle", "Government Exams"); request.setAttribute("activeAdmin", "exams"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<c:choose>
<c:when test="${formMode}">
  <form method="post" action="${ctx}/admin/exams" class="k-card p-4 mb-4 needs-validation" novalidate>
    <input type="hidden" name="id" value="${exam.id}">
    <div class="alert alert-warning small">Replace sample text with <strong>verified</strong> information from the official notification, add the official website URL, then untick the "sample data" box.</div>
    <div class="row g-3">
      <k:field name="name" label="Exam name" value="${exam.name}" req="true"/>
      <k:field name="department" label="Department" value="${exam.department}" req="true"/>
      <k:field name="category" label="Exam category" value="${exam.category}" req="true" col="4" hint="Example: State Services, Teaching, Defence"/>
      <div class="col-md-4"><label class="form-label" for="qualification">Minimum qualification <span class="text-danger">*</span></label><select class="form-select" id="qualification" name="qualification" required><option value="">-- Select --</option>
        <c:forEach items="${applicationScope.qualifications}" var="q"><option ${exam.qualification == q ? 'selected' : ''}>${q}</option></c:forEach></select></div>
      <k:field name="minAge" label="Min age" type="number" value="${exam.minAge}" col="2" extra="min=0 max=60"/>
      <k:field name="maxAge" label="Max age (0 = none)" type="number" value="${exam.maxAge}" col="2" extra="min=0 max=70"/>
      <k:field name="eligibility" label="Eligibility / educational qualification" value="${exam.eligibility}" rows="2" col="12"/>
      <k:field name="ageLimit" label="Age limit (text)" value="${exam.ageLimit}" col="12"/>
      <k:field name="applicationProcess" label="Application process" value="${exam.applicationProcess}" rows="2"/>
      <k:field name="registrationInfo" label="Registration information" value="${exam.registrationInfo}" rows="2"/>
      <k:field name="examPattern" label="Exam pattern" value="${exam.examPattern}" rows="2"/>
      <k:field name="syllabus" label="Syllabus" value="${exam.syllabus}" rows="2"/>
      <k:field name="selectionProcess" label="Selection process" value="${exam.selectionProcess}" rows="2"/>
      <k:field name="instructions" label="Examination instructions" value="${exam.instructions}" rows="2"/>
      <k:field name="officialUrl" label="Official source URL" type="url" value="${exam.officialUrl}" hint="https://..."/>
      <k:field name="interestTags" label="Interest tags" value="${exam.interestTags}" hint="Comma separated e.g. Government Jobs,Teaching"/>
      <div class="col-12"><div class="form-check"><input class="form-check-input" type="checkbox" name="demo" id="demo" ${exam.demo ? 'checked' : ''}><label class="form-check-label" for="demo">Sample / unverified data (shows DEMO label to students)</label></div></div>
    </div>
    <div class="mt-4"><button class="btn btn-primary" type="submit">Save exam</button> <a class="btn btn-outline-secondary" href="${ctx}/admin/exams">Back to list</a></div>
  </form>

  <c:if test="${exam.id > 0}">
  <div class="row g-3">
    <div class="col-lg-6"><div class="k-card p-3"><h2 class="h6"><i class="fa-solid fa-calendar-days me-1 text-warning"></i>Exam dates</h2>
      <table class="table table-sm"><tbody><c:forEach items="${dates}" var="d"><tr><td><fmt:formatDate value="${d.eventDate}" pattern="dd-MM-yyyy"/></td><td><c:out value="${d.eventName}"/></td><td><c:choose><c:when test="${d.official}"><span class="verified-pill">Official</span></c:when><c:otherwise><span class="demo-pill">DEMO</span></c:otherwise></c:choose></td>
        <td class="text-end"><form method="post" action="${ctx}/admin/exams" data-confirm="Remove this date?"><input type="hidden" name="action" value="deleteDate"><input type="hidden" name="examId" value="${exam.id}"><input type="hidden" name="id" value="${d.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-xmark"></i></button></form></td></tr></c:forEach>
        <c:if test="${empty dates}"><tr><td class="text-muted">No dates yet.</td></tr></c:if></tbody></table>
      <form method="post" action="${ctx}/admin/exams" class="row g-2"><input type="hidden" name="action" value="addDate"><input type="hidden" name="examId" value="${exam.id}">
        <div class="col-6"><input class="form-control form-control-sm" name="eventName" placeholder="Event (e.g. Last date to apply)" required></div>
        <div class="col-6"><input class="form-control form-control-sm" type="date" name="eventDate" required></div>
        <div class="col-8"><div class="form-check"><input class="form-check-input" type="checkbox" name="official" id="off"><label class="form-check-label small" for="off">Official date (taken from the notification)</label></div></div>
        <div class="col-4 text-end"><button class="btn btn-sm btn-primary">Add date</button></div></form></div></div>
    <div class="col-lg-6"><div class="k-card p-3"><h2 class="h6"><i class="fa-solid fa-location-dot me-1 text-warning"></i>Exam centers</h2>
      <table class="table table-sm"><tbody><c:forEach items="${centers}" var="c"><tr><td><c:out value="${c.district}"/></td><td><c:out value="${c.centerName}"/></td>
        <td class="text-end"><form method="post" action="${ctx}/admin/exams" data-confirm="Remove this center?"><input type="hidden" name="action" value="deleteCenter"><input type="hidden" name="examId" value="${exam.id}"><input type="hidden" name="id" value="${c.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-xmark"></i></button></form></td></tr></c:forEach>
        <c:if test="${empty centers}"><tr><td class="text-muted">No centers yet.</td></tr></c:if></tbody></table>
      <form method="post" action="${ctx}/admin/exams" class="row g-2"><input type="hidden" name="action" value="addCenter"><input type="hidden" name="examId" value="${exam.id}">
        <div class="col-6"><select class="form-select form-select-sm" name="district" required><option value="">District</option><c:forEach items="${applicationScope.districts}" var="d"><option>${d}</option></c:forEach></select></div>
        <div class="col-6"><input class="form-control form-control-sm" name="centerName" placeholder="Center name" required></div>
        <div class="col-9"><input class="form-control form-control-sm" name="address" placeholder="Address"></div>
        <div class="col-3 text-end"><button class="btn btn-sm btn-primary">Add</button></div></form></div></div>
  </div>
  </c:if>
</c:when>
<c:otherwise>
  <div class="d-flex justify-content-between mb-3"><p class="text-muted mb-0">${fn:length(exams)} exams &ndash; open an exam to manage its dates and centers.</p><a class="btn btn-primary" href="${ctx}/admin/exams?action=new"><i class="fa-solid fa-plus me-1"></i>Add exam</a></div>
  <div class="k-card table-card"><div class="table-responsive"><table class="table table-hover align-middle"><thead><tr><th>Name</th><th>Department</th><th>Category</th><th>Qualification</th><th>Data</th><th>Updated</th><th></th></tr></thead><tbody>
    <c:forEach items="${exams}" var="e"><tr><td><c:out value="${e.name}"/></td><td class="small"><c:out value="${e.department}"/></td><td><c:out value="${e.category}"/></td><td><c:out value="${e.qualification}"/></td>
      <td><c:choose><c:when test="${e.demo}"><span class="demo-pill">DEMO</span></c:when><c:otherwise><span class="verified-pill">Verified</span></c:otherwise></c:choose></td><td class="small"><fmt:formatDate value="${e.lastUpdated}" pattern="dd-MM-yyyy"/></td>
      <td class="text-end text-nowrap"><a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/exams?action=edit&id=${e.id}"><i class="fa-solid fa-pen"></i></a>
        <form class="d-inline" method="post" action="${ctx}/admin/exams" data-confirm="Delete this exam with its dates and centers?"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${e.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  </tbody></table></div></div>
</c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
