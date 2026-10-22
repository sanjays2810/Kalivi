<%@ tag body-content="empty" pageEncoding="UTF-8" description="Interest checkboxes" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ attribute name="selected" description="comma separated interests already chosen" %>
<div class="d-flex flex-wrap gap-2">
  <c:forEach items="${applicationScope.interestOptions}" var="i" varStatus="s">
    <input type="checkbox" class="btn-check" id="int_${s.index}" name="interests" value="<c:out value='${i}'/>" ${fn:contains(selected, i) ? 'checked' : ''}>
    <label class="btn btn-outline-primary btn-sm chip" for="int_${s.index}"><c:out value="${i}"/></label>
  </c:forEach>
</div>
