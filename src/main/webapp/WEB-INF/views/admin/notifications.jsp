<% request.setAttribute("pageTitle", "Notifications"); request.setAttribute("activeAdmin", "notifications"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<c:choose>
<c:when test="${formMode}">
  <form method="post" action="${ctx}/admin/notifications" class="k-card p-4 needs-validation" novalidate><input type="hidden" name="id" value="${item.id}">
    <div class="row g-3"><k:field name="title" label="Title" value="${item.title}" req="true" col="12"/><k:field name="message" label="Message" value="${item.message}" rows="3" req="true" col="12"/>
      <div class="col-12"><div class="form-check"><input class="form-check-input" type="checkbox" name="demo" id="demo" ${item.demo ? 'checked' : ''}><label class="form-check-label" for="demo">Sample / demo notification</label></div></div></div>
    <div class="mt-4"><button class="btn btn-primary">Publish</button> <a class="btn btn-outline-secondary" href="${ctx}/admin/notifications">Cancel</a></div></form>
</c:when>
<c:otherwise>
  <div class="d-flex justify-content-between mb-3"><p class="text-muted mb-0">Shown on student dashboards (latest 5).</p><a class="btn btn-primary" href="${ctx}/admin/notifications?action=new"><i class="fa-solid fa-plus me-1"></i>New notification</a></div>
  <div class="k-card table-card"><table class="table table-hover align-middle"><thead><tr><th>Title</th><th>Message</th><th>Posted</th><th></th></tr></thead><tbody>
    <c:forEach items="${items}" var="n"><tr><td><c:out value="${n.title}"/> <c:if test="${n.demo}"><span class="demo-pill">DEMO</span></c:if></td><td class="small"><c:out value="${n.message}"/></td><td class="small text-nowrap"><fmt:formatDate value="${n.createdAt}" pattern="dd-MM-yyyy"/></td>
      <td class="text-end text-nowrap"><a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/notifications?action=edit&id=${n.id}"><i class="fa-solid fa-pen"></i></a>
        <form class="d-inline" method="post" action="${ctx}/admin/notifications" data-confirm="Delete this notification?"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${n.id}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  </tbody></table></div>
</c:otherwise></c:choose>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
