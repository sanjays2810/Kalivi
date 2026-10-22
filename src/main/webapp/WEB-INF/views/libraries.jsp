<% request.setAttribute("pageTitle", "Nearby Libraries"); request.setAttribute("activeNav", "resources"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Nearby Libraries & Learning Centres" subtitle="Find reading rooms and competitive-exam study spaces in your district."/>
<div class="container section pt-4">
  <form class="k-card p-3 mb-4 no-print" method="get" action="${ctx}/libraries"><div class="row g-2">
    <div class="col-md-4"><select class="form-select" name="district"><option value="">All districts</option><c:forEach items="${applicationScope.districts}" var="d"><option ${param.district == d ? 'selected' : ''}>${d}</option></c:forEach></select></div>
    <div class="col-md-5"><input class="form-control" name="q" placeholder="Search by name or location" value="<c:out value='${param.q}'/>"></div>
    <div class="col-md-3 d-flex gap-2"><button class="btn btn-primary" type="submit">Search</button><a class="btn btn-outline-secondary" href="${ctx}/libraries">Reset</a></div></div></form>
  <c:choose>
    <c:when test="${empty libraries}"><div class="k-card empty-state"><i class="fa-solid fa-building-columns"></i><p>No libraries listed for this search yet.</p></div></c:when>
    <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3"><c:forEach items="${libraries}" var="l"><div class="col"><div class="k-card hoverable p-3 h-100">
      <div class="d-flex justify-content-between"><span class="tag"><c:out value="${l.district}"/></span><c:if test="${l.demo}"><span class="demo-pill">SAMPLE</span></c:if></div>
      <h3 class="h6 mt-2"><c:out value="${l.name}"/></h3>
      <p class="small mb-1"><i class="fa-solid fa-location-dot text-muted me-1"></i><c:out value="${l.address}"/></p>
      <p class="small mb-1"><i class="fa-solid fa-phone text-muted me-1"></i><c:out value="${l.contact}"/></p>
      <p class="small mb-2"><i class="fa-regular fa-clock text-muted me-1"></i><c:out value="${l.openingHours}"/></p>
      <c:forEach items="${fn:split(l.facilities, ',')}" var="f"><span class="tag green"><c:out value="${f}"/></span></c:forEach>
    </div></div></c:forEach></div></c:otherwise>
  </c:choose>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
