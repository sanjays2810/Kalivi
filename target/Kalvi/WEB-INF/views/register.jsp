<% request.setAttribute("pageTitle", "Register"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="auth-wrap">
  <div class="k-card auth-card wide">
    <h1 class="h3 mb-1">Create your Kalvi account</h1><p class="text-muted small mb-3">Tell us about your 12th results so we can personalise your guidance.</p>
    <c:if test="${not empty errors}"><div class="alert alert-danger"><ul class="mb-0"><c:forEach items="${errors}" var="e"><li><c:out value="${e}"/></li></c:forEach></ul></div></c:if>
    <form method="post" action="${ctx}/register" class="needs-validation" novalidate>
      <div class="row g-3">
        <k:field name="fullName" label="Full Name" value="${param.fullName}" req="true" extra="minlength=3 maxlength=100"/>
        <k:field name="email" label="Email" type="email" value="${param.email}" req="true"/>
        <k:field name="mobile" label="Mobile Number" value="${param.mobile}" req="true" extra="pattern=[6-9][0-9]{9} maxlength=10 inputmode=numeric" hint="10-digit Indian mobile number"/>
        <k:field name="dob" label="Date of Birth" type="date" value="${param.dob}" req="true"/>
        <div class="col-md-6"><label class="form-label" for="password">Password <span class="text-danger">*</span></label>
          <input class="form-control" type="password" id="password" name="password" minlength="8" pattern="(?=.*[A-Za-z])(?=.*[0-9]).{8,}" required>
          <div class="form-text">Min 8 characters with a letter and a number.</div></div>
        <div class="col-md-6"><label class="form-label" for="confirmPassword">Confirm Password <span class="text-danger">*</span></label>
          <input class="form-control" type="password" id="confirmPassword" name="confirmPassword" required>
          <div class="invalid-feedback">Passwords must match.</div></div>
        <div class="col-md-6"><label class="form-label" for="gender">Gender <span class="text-danger">*</span></label>
          <select class="form-select" id="gender" name="gender" required><option value="">-- Select --</option>
            <c:forEach items="${applicationScope.genders}" var="g"><option ${param.gender == g ? 'selected' : ''}>${g}</option></c:forEach></select></div>
        <div class="col-md-6"><label class="form-label" for="district">District <span class="text-danger">*</span></label>
          <select class="form-select" id="district" name="district" required><option value="">-- Select --</option>
            <c:forEach items="${applicationScope.districts}" var="d"><option ${param.district == d ? 'selected' : ''}>${d}</option></c:forEach></select></div>
        <div class="col-md-6"><label class="form-label" for="group12">12th Group <span class="text-danger">*</span></label>
          <select class="form-select" id="group12" name="group12" required><option value="">-- Select --</option>
            <c:forEach items="${applicationScope.groups}" var="g"><option ${param.group12 == g ? 'selected' : ''}>${g}</option></c:forEach></select></div>
        <div class="col-md-6"><label class="form-label" for="marks">12th Marks (%) <span class="text-danger">*</span></label>
          <input class="form-control" type="number" step="0.01" min="0" max="100" id="marks" name="marks" value="<c:out value='${param.marks}'/>" required></div>
        <div class="col-12"><label class="form-label">Interests</label><k:interests selected="${fn:join(paramValues.interests, ',')}"/></div>
        <div class="col-md-6"><label class="form-label" for="sectorPreference">Government / private preference</label>
          <select class="form-select" id="sectorPreference" name="sectorPreference"><c:forEach items="${applicationScope.sectors}" var="x"><option ${(empty param.sectorPreference ? 'Both' : param.sectorPreference) == x ? 'selected' : ''}>${x}</option></c:forEach></select></div>
        <k:field name="preferredCareer" label="Preferred career (optional)" value="${param.preferredCareer}"/>
      </div>
      <button class="btn btn-primary mt-4 px-4" type="submit">Register</button>
      <span class="small ms-2">Already registered? <a href="${ctx}/login">Login</a></span>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
