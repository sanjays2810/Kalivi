<%@ page isErrorPage="true" %>
<%
  // Never print the stack trace to the user; the container already logs it.
  Integer status = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
  Throwable cause = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
  if (request.getAttribute("errorMessage") == null) {
    String msg;
    boolean db = false;
    for (Throwable t = cause; t != null; t = t.getCause()) { if (t instanceof java.sql.SQLException || t instanceof com.kalvi.util.DataAccessException) db = true; }
    if (db) msg = "We could not connect to the database. Please try again in a few minutes.";
    else if (status != null && status == 404) msg = "The page you are looking for does not exist.";
    else if (status != null && status == 403) msg = "Unauthorized access. You do not have permission to open this page.";
    else msg = "Something went wrong on our side. Please try again.";
    request.setAttribute("errorMessage", msg);
    request.setAttribute("errorTitle", status != null && status == 404 ? "Page not found" : status != null && status == 403 ? "Access denied" : "Oops!");
  }
  request.setAttribute("errorCode", status != null ? status : response.getStatus());
%>
<% request.setAttribute("pageTitle", "Error"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="container section text-center" style="max-width:640px">
  <div class="display-1 fw-bold" style="color:var(--k-gold)"><c:out value="${errorCode}"/></div>
  <h1 class="h2"><c:out value="${errorTitle}"/></h1>
  <p class="text-muted"><c:out value="${errorMessage}"/></p>
  <div class="d-flex gap-2 justify-content-center"><a class="btn btn-primary" href="${ctx}/">Go to Home</a><a class="btn btn-outline-primary" href="javascript:history.back()">Go back</a></div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
