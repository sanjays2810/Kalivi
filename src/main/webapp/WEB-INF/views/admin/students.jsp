<% request.setAttribute("pageTitle", "Students"); request.setAttribute("activeAdmin", "students"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<div class="k-card table-card"><div class="table-responsive"><table class="table table-hover align-middle"><thead><tr><th>Name</th><th>Email</th><th>Mobile</th><th>District</th><th>12th group</th><th>Marks</th><th></th></tr></thead><tbody>
  <c:forEach items="${students}" var="s"><tr><td><c:out value="${s.fullName}"/></td><td><c:out value="${s.email}"/></td><td><c:out value="${s.mobile}"/></td><td><c:out value="${s.district}"/></td><td><c:out value="${s.group12}"/></td><td>${s.marks}%</td>
    <td class="text-end"><form method="post" action="${ctx}/admin/students" data-confirm="Delete this student and all their saved data?"><input type="hidden" name="id" value="${s.userId}"><button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button></form></td></tr></c:forEach>
  <c:if test="${empty students}"><tr><td colspan="7" class="empty-state">No students registered yet.</td></tr></c:if></tbody></table></div></div>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
