<%@ tag body-content="empty" pageEncoding="UTF-8" description="Source / last-updated notice for exam information" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ attribute name="exam" type="com.kalvi.model.GovernmentExam" required="true" %>
<div class="source-box">
  <c:choose>
    <c:when test="${exam.demo}"><span class="demo-pill me-1">DEMO DATA</span> This is <strong>sample information</strong> and not verified. Do not rely on it for applying.</c:when>
    <c:otherwise><span class="verified-pill me-1"><i class="fa-solid fa-circle-check"></i> Verified by admin</span></c:otherwise>
  </c:choose>
  <div class="mt-1"><strong>Source:</strong>
    <c:choose><c:when test="${not empty exam.officialUrl}"><a href="<c:out value='${exam.officialUrl}'/>" target="_blank" rel="noopener noreferrer">Official Website <i class="fa-solid fa-arrow-up-right-from-square small"></i></a></c:when><c:otherwise>Not provided</c:otherwise></c:choose>
    &nbsp;|&nbsp; <strong>Last Updated:</strong> <fmt:formatDate value="${exam.lastUpdated}" pattern="dd-MM-yyyy"/></div>
</div>
