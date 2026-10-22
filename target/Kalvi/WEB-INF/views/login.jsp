<% request.setAttribute("pageTitle", "Login"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="auth-wrap">
  <div class="k-card auth-card">
    <div class="text-center mb-3"><img src="${ctx}/images/logo.svg" width="54" alt=""><h1 class="h3 mt-2">Student Login</h1><p class="text-muted small">Welcome back! Continue your career journey.</p></div>
    <c:if test="${not empty info}"><div class="alert alert-info py-2"><c:out value="${info}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger py-2"><i class="fa-solid fa-circle-exclamation me-1"></i><c:out value="${error}"/></div></c:if>
    <form method="post" action="${ctx}/login" class="needs-validation" novalidate>
      <div class="mb-3"><label class="form-label" for="email">Email</label>
        <input class="form-control" type="email" id="email" name="email" value="<c:out value='${param.email}'/>" required autofocus>
        <div class="invalid-feedback">Enter a valid email.</div></div>
      <div class="mb-3"><label class="form-label" for="password">Password</label>
        <input class="form-control" type="password" id="password" name="password" required>
        <div class="invalid-feedback">Password is required.</div></div>
      <button class="btn btn-primary w-100" type="submit">Login</button>
    </form>
    <p class="text-center small mt-3 mb-1">New to Kalvi? <a href="${ctx}/register">Create an account</a></p>
    <p class="text-center small mb-0"><a href="${ctx}/admin/login">Admin login</a></p>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
