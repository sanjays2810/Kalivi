<% request.setAttribute("pageTitle", "Settings"); request.setAttribute("activeAdmin", "settings"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<div class="k-card p-4" style="max-width:520px"><h2 class="h5">Change password</h2>
  <p class="small text-muted">Signed in as <strong><c:out value="${sessionScope.user.email}"/></strong>. Change the demo password before any real use.</p>
  <c:if test="${not empty error}"><div class="alert alert-danger py-2"><c:out value="${error}"/></div></c:if>
  <form method="post" action="${ctx}/admin/settings" class="needs-validation" novalidate>
    <div class="mb-3"><label class="form-label">Current password</label><input class="form-control" type="password" name="currentPassword" required></div>
    <div class="mb-3"><label class="form-label">New password</label><input class="form-control" type="password" name="newPassword" minlength="8" required></div>
    <div class="mb-3"><label class="form-label">Confirm new password</label><input class="form-control" type="password" name="confirmPassword" required></div>
    <button class="btn btn-primary">Update password</button></form></div>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
