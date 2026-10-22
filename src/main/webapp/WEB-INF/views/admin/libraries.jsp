<% request.setAttribute("pageTitle", "Libraries"); request.setAttribute("activeAdmin", "libraries"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<c:choose>
<c:when test="${formMode}">
  <form method="post" action="${ctx}/admin/libraries" class="k-card p-4 needs-validation" novalidate><input type="hidden" name="id" value="${item.id}">
    <div class="row g-3">
      <k:field name="name" label="Library name" value="${item.name}" req="true"/>
      <div class="col-md-6"><label class="form-label" for="district">District <span class="text-danger">*</span></label><select class="form-select" id="district" name="district" required><option value="">-- Select --</option>
        <c:forEach items="${applicationScope.districts}" var="d"><option ${item.district == d ? 'selected' : ''}>${d}</option></c:forEach></select></div>
      <k:field name="location" label="Location / area" value="${item.location}"/>
      <k:field name="contact" label="Contact" value="${item.contact}"/>
      <k:field name="address" label="Address" value="${item.address}" req="true" col="12"/>
      <k:field name="facilities" label="Facilities" value="${item.facilities}" hint="Comma separated"/>
      <k:field name="openingHours" label="Opening hours" value="${item.openingHours}"/>
      <div class="col-12"><div class="form-check"><input class="form-check-input" type="checkbox" name="demo" id="demo" ${item.demo ? 'checked' : ''}><label class="form-check-label" for="demo">Sample / unverified entry</label></div></div>
    </div>
    <div class="mt-4"><button class="btn btn-primary">Save library</button> <a class="btn btn-outline-secondary" href="${ctx}/admin/libraries">Cancel</a></div></form>
</c:when>
<c:otherwise>
  <div class="d-flex justify-content-between mb-3"><p class="text-muted mb-0">${fn:length(items)} libraries</p><a class="btn btn-primary" href="${ctx}/admin/libraries?action=new"><i class="fa-solid fa-plus me-1"></i>Add library</a></div>
  <div class="k-card table-card"><div class="table-responsive"><table class="table table-hover align-middle"><thead><tr><th>Name</th><th>District</th><th>Address</th><th>Hours</th><th></th></tr></thead><tbody>
    <c:forEach items="${items}" var="l"><tr><td><c:out value="${l.name}"/> <c:if test="${l.demo}"><span class="demo-pill">SAMPLE</span></c:if></td><td><c:out value="${l.district}"/></td><td class="small"><c:out value="${l.address}"/></td><td class="small"><c:out value="${l.openingHours}"/></td>
      <td class="text-end text-nowrap"><a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/libraries?action=edit&id=${l.id}"><i class="fa-solid fa-pen"></i></a>
        <form class="d-inline" method="post" action="${ctx}/admin/libraries" data-confirm="Delete this library?"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${l.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  </tbody></table></div></div>
</c:otherwise></c:choose>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
