<%@ tag body-content="empty" pageEncoding="UTF-8" description="12th details used by profile and roadmap forms" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="k" tagdir="/WEB-INF/tags" %>
<%@ attribute name="s" type="java.lang.Object" description="Student bean or null" %>
<%@ attribute name="showDistrict" %>
<div class="col-md-6">
  <label class="form-label" for="group12">12th Group <span class="text-danger">*</span></label>
  <select class="form-select" id="group12" name="group12" required>
    <option value="">-- Select --</option>
    <c:forEach items="${applicationScope.groups}" var="g"><option value="<c:out value='${g}'/>" ${g == s.group12 ? 'selected' : ''}><c:out value="${g}"/></option></c:forEach>
  </select>
</div>
<div class="col-md-6">
  <label class="form-label" for="marks">12th Marks (%) <span class="text-danger">*</span></label>
  <input class="form-control" id="marks" name="marks" type="number" step="0.01" min="0" max="100" value="${s.marks > 0 ? s.marks : ''}" required>
</div>
<div class="col-12">
  <label class="form-label">Interests <span class="form-text">(choose all that apply)</span></label>
  <k:interests selected="${s.interests}"/>
</div>
<k:field name="preferredCareer" label="Preferred career (optional)" value="${s.preferredCareer}" hint="Example: software developer, teacher, nurse, bank officer"/>
<div class="col-md-6">
  <label class="form-label" for="sectorPreference">Government / private preference</label>
  <select class="form-select" id="sectorPreference" name="sectorPreference">
    <c:forEach items="${applicationScope.sectors}" var="x"><option value="${x}" ${(empty s.sectorPreference ? 'Both' : s.sectorPreference) == x ? 'selected' : ''}>${x}</option></c:forEach>
  </select>
</div>
<c:if test="${showDistrict == 'true'}">
  <div class="col-md-6">
    <label class="form-label" for="district">District <span class="text-danger">*</span></label>
    <select class="form-select" id="district" name="district" required>
      <option value="">-- Select --</option>
      <c:forEach items="${applicationScope.districts}" var="d"><option value="${d}" ${d == s.district ? 'selected' : ''}>${d}</option></c:forEach>
    </select>
  </div>
</c:if>
