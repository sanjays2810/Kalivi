<% request.setAttribute("pageTitle", "Admin Login"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="auth-wrap"><div class="k-card auth-card">
  <div class="text-center mb-3"><span class="avatar mx-auto mb-2" style="width:54px;height:54px"><i class="fa-solid fa-user-shield"></i></span><h1 class="h3">Admin Login</h1><p class="text-muted small">Authorised administrators only.</p></div>
  <c:if test="${not empty info}"><div class="alert alert-info py-2"><c:out value="${info}"/></div></c:if>
  <c:if test="${not empty error}"><div class="alert alert-danger py-2"><c:out value="${error}"/></div></c:if>
  <form method="post" action="${ctx}/admin/login" class="needs-validation" novalidate>
    <div class="mb-3"><label class="form-label" for="email">Admin email</label><input class="form-control" type="email" id="email" name="email" value="<c:out value='${param.email}'/>" required autofocus></div>
    <div class="mb-3"><label class="form-label" for="password">Password</label><input class="form-control" type="password" id="password" name="password" required></div>
    <button class="btn btn-primary w-100" type="submit">Login to admin panel</button>
  </form>
  <p class="text-center small mt-3 mb-0"><a href="${ctx}/login">Student login</a></p>
</div></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
