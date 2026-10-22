<% request.setAttribute("pageTitle", "Resources"); request.setAttribute("activeAdmin", "resources"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<c:choose>
<c:when test="${formMode}">
  <form method="post" action="${ctx}/admin/resources" class="k-card p-4 needs-validation" novalidate><input type="hidden" name="id" value="${item.id}">
    <div class="row g-3">
      <k:field name="title" label="Title" value="${item.title}" req="true"/>
      <div class="col-md-6"><label class="form-label" for="category">Category <span class="text-danger">*</span></label><select class="form-select" id="category" name="category" required><option value="">-- Select --</option>
        <c:forEach items="${applicationScope.resourceCategories}" var="c"><option ${item.category == c ? 'selected' : ''}>${c}</option></c:forEach></select></div>
      <k:field name="link" label="Resource link" type="url" value="${item.link}" req="true" col="12" hint="Must start with https://"/>
      <k:field name="description" label="Description" value="${item.description}" rows="3" col="12"/>
    </div>
    <div class="mt-4"><button class="btn btn-primary">Save resource</button> <a class="btn btn-outline-secondary" href="${ctx}/admin/resources">Cancel</a></div></form>
</c:when>
<c:otherwise>
  <div class="d-flex justify-content-between mb-3"><p class="text-muted mb-0">${fn:length(items)} resources</p><a class="btn btn-primary" href="${ctx}/admin/resources?action=new"><i class="fa-solid fa-plus me-1"></i>Add resource</a></div>
  <div class="k-card table-card"><div class="table-responsive"><table class="table table-hover align-middle"><thead><tr><th>Title</th><th>Category</th><th>Link</th><th>Added</th><th></th></tr></thead><tbody>
    <c:forEach items="${items}" var="r"><tr><td><c:out value="${r.title}"/></td><td><c:out value="${r.category}"/></td><td class="small"><a href="<c:out value='${r.link}'/>" target="_blank" rel="noopener noreferrer"><c:out value="${r.link}"/></a></td><td class="small"><fmt:formatDate value="${r.dateAdded}" pattern="dd-MM-yyyy"/></td>
      <td class="text-end text-nowrap"><a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/resources?action=edit&id=${r.id}"><i class="fa-solid fa-pen"></i></a>
        <form class="d-inline" method="post" action="${ctx}/admin/resources" data-confirm="Delete this resource?"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${r.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  </tbody></table></div></div>
</c:otherwise></c:choose>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
