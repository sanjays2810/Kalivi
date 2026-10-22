<%@ tag body-content="empty" pageEncoding="UTF-8" description="Bootstrap form field (input, textarea or select)" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="value" %>
<%@ attribute name="type" %>
<%@ attribute name="rows" %>
<%@ attribute name="req" %>
<%@ attribute name="col" %>
<%@ attribute name="options" description="comma separated list => renders a select" %>
<%@ attribute name="hint" %>
<%@ attribute name="extra" description="extra HTML attributes for the input" %>
<div class="col-md-${empty col ? 6 : col}">
  <label class="form-label" for="f_${name}">${label}<c:if test="${req == 'true'}"> <span class="text-danger">*</span></c:if></label>
  <c:choose>
    <c:when test="${not empty options}">
      <select class="form-select" id="f_${name}" name="${name}" ${req == 'true' ? 'required' : ''}>
        <option value="">-- Select --</option>
        <c:forEach items="${fn:split(options, ',')}" var="o"><option value="<c:out value='${o}'/>" ${o == value ? 'selected' : ''}><c:out value="${o}"/></option></c:forEach>
      </select>
    </c:when>
    <c:when test="${not empty rows}">
      <textarea class="form-control" id="f_${name}" name="${name}" rows="${rows}" ${req == 'true' ? 'required' : ''}><c:out value="${value}"/></textarea>
    </c:when>
    <c:otherwise>
      <input class="form-control" id="f_${name}" name="${name}" type="${empty type ? 'text' : type}" value="<c:out value='${value}'/>" ${req == 'true' ? 'required' : ''} ${extra}>
    </c:otherwise>
  </c:choose>
  <c:if test="${not empty hint}"><div class="form-text">${hint}</div></c:if>
</div>
