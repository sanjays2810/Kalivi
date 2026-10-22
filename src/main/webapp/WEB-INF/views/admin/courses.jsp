<% request.setAttribute("pageTitle", "Courses"); request.setAttribute("activeAdmin", "courses"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<c:choose>
<c:when test="${formMode}">
  <form method="post" action="${ctx}/admin/courses" class="k-card p-4 needs-validation" novalidate>
    <input type="hidden" name="id" value="${course.id}">
    <div class="row g-3">
      <k:field name="name" label="Course name" value="${course.name}" req="true"/>
      <div class="col-md-6"><label class="form-label" for="categoryId">Category <span class="text-danger">*</span></label><select class="form-select" id="categoryId" name="categoryId" required><option value="">-- Select --</option>
        <c:forEach items="${categories}" var="c"><option value="${c.id}" ${course.categoryId == c.id ? 'selected' : ''}><c:out value="${c.name}"/></option></c:forEach></select></div>
      <k:field name="duration" label="Duration" value="${course.duration}" req="true" col="4" hint="Example: 4 Years"/>
      <k:field name="minMarks" label="Approx. marks that help (%)" type="number" value="${course.minMarks}" col="4" extra="min=0 max=100 step=0.1"/>
      <k:field name="careerField" label="Career field" value="${course.careerField}" col="4" hint="Example: Information Technology"/>
      <k:field name="eligibility" label="Eligibility" value="${course.eligibility}" col="12"/>
      <k:field name="requiredGroups" label="Required 12th groups" value="${course.requiredGroups}" req="true" col="12" hint="Comma separated: Computer Science,Bio-Maths,Commerce... or the word Any"/>
      <k:field name="admissionRequirements" label="Approximate admission requirements" value="${course.admissionRequirements}" rows="2" col="12"/>
      <k:field name="careerOpportunities" label="Career opportunities" value="${course.careerOpportunities}" rows="2" hint="Comma separated"/>
      <k:field name="jobOpportunities" label="Job opportunities" value="${course.jobOpportunities}" rows="2"/>
      <k:field name="higherStudies" label="Higher studies" value="${course.higherStudies}" rows="2"/>
      <k:field name="governmentOpportunities" label="Government opportunities" value="${course.governmentOpportunities}" rows="2"/>
      <k:field name="skills" label="Skills required" value="${course.skills}" rows="2" hint="Comma separated"/>
      <k:field name="interestTags" label="Interest tags" value="${course.interestTags}" rows="2" hint="Comma separated, use the interest names: Programming, Data &amp; AI, Healthcare ..."/>
      <k:field name="description" label="Course description" value="${course.description}" rows="3" col="12"/>
      <div class="col-12"><div class="form-check"><input class="form-check-input" type="checkbox" name="demo" id="demo" ${course.demo ? 'checked' : ''}><label class="form-check-label" for="demo">This is sample / unverified information (shows a DEMO label)</label></div></div>
    </div>
    <div class="mt-4"><button class="btn btn-primary" type="submit">Save course</button> <a class="btn btn-outline-secondary" href="${ctx}/admin/courses">Cancel</a></div>
  </form>
</c:when>
<c:otherwise>
  <div class="d-flex justify-content-between mb-3"><p class="text-muted mb-0">${fn:length(courses)} courses</p><a class="btn btn-primary" href="${ctx}/admin/courses?action=new"><i class="fa-solid fa-plus me-1"></i>Add course</a></div>
  <div class="k-card table-card"><div class="table-responsive"><table class="table table-hover align-middle"><thead><tr><th>Name</th><th>Category</th><th>Duration</th><th>Groups</th><th>Data</th><th></th></tr></thead><tbody>
    <c:forEach items="${courses}" var="c"><tr><td><c:out value="${c.name}"/></td><td><c:out value="${c.categoryName}"/></td><td><c:out value="${c.duration}"/></td><td class="small"><c:out value="${c.requiredGroups}"/></td>
      <td><c:choose><c:when test="${c.demo}"><span class="demo-pill">DEMO</span></c:when><c:otherwise><span class="verified-pill">Verified</span></c:otherwise></c:choose></td>
      <td class="text-end text-nowrap"><a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/courses?action=edit&id=${c.id}"><i class="fa-solid fa-pen"></i></a>
        <form class="d-inline" method="post" action="${ctx}/admin/courses" data-confirm="Delete this course?"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${c.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  </tbody></table></div></div>
</c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
