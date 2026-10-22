<% request.setAttribute("pageTitle", "My Profile"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="My Profile" breadcrumbParent="Dashboard" parentUrl="/student/dashboard" subtitle="Keep your 12th details and interests up to date for better recommendations."/>
<div class="container section pt-4"><div class="k-card p-4">
  <c:if test="${not empty errors}"><div class="alert alert-danger"><ul class="mb-0"><c:forEach items="${errors}" var="e"><li><c:out value="${e}"/></li></c:forEach></ul></div></c:if>
  <form method="post" action="${ctx}/student/profile" class="needs-validation" novalidate><div class="row g-3">
    <k:field name="fullName" label="Full Name" value="${student.fullName}" req="true"/>
    <div class="col-md-6"><label class="form-label">Email</label><input class="form-control" value="<c:out value='${student.email}'/>" disabled></div>
    <k:field name="mobile" label="Mobile Number" value="${student.mobile}" req="true" extra="pattern=[6-9][0-9]{9} maxlength=10"/>
    <k:field name="dob" label="Date of Birth" type="date" value="${student.dob}" req="true"/>
    <div class="col-md-6"><label class="form-label">Gender</label><select class="form-select" name="gender" required><c:forEach items="${applicationScope.genders}" var="g"><option ${student.gender == g ? 'selected' : ''}>${g}</option></c:forEach></select></div>
    <k:profileFields s="${student}" showDistrict="true"/>
  </div><button class="btn btn-primary mt-4" type="submit">Save changes</button> <a class="btn btn-outline-secondary mt-4" href="${ctx}/student/dashboard">Cancel</a></form>
</div></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
