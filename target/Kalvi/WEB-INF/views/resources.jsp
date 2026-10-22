<% request.setAttribute("pageTitle", "Resources"); request.setAttribute("activeNav", "resources"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="Resources" subtitle="Study materials, official websites, syllabus, scholarships and useful links."/>
<div class="container section pt-4">
  <form class="k-card p-3 mb-4 no-print" method="get" action="${ctx}/resources"><div class="row g-2">
    <div class="col-md-5"><input class="form-control" name="q" placeholder="Search resources..." value="<c:out value='${param.q}'/>"></div>
    <div class="col-md-4"><select class="form-select" name="category"><option value="">All categories</option><c:forEach items="${applicationScope.resourceCategories}" var="c"><option ${param.category == c ? 'selected' : ''}>${c}</option></c:forEach></select></div>
    <div class="col-md-3 d-flex gap-2"><button class="btn btn-primary" type="submit">Search</button><a class="btn btn-outline-secondary" href="${ctx}/resources">Reset</a></div></div></form>
  <c:choose>
    <c:when test="${empty resources}"><div class="k-card empty-state"><i class="fa-regular fa-folder-open"></i><p>No resources found.</p></div></c:when>
    <c:otherwise><div class="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3"><c:forEach items="${resources}" var="r"><div class="col"><div class="k-card hoverable p-3 h-100 d-flex flex-column">
      <span class="tag green align-self-start"><c:out value="${r.category}"/></span><h3 class="h6 mt-2"><c:out value="${r.title}"/></h3>
      <p class="small text-muted"><c:out value="${r.description}"/></p>
      <div class="mt-auto d-flex justify-content-between align-items-center"><span class="small text-muted">Added <fmt:formatDate value="${r.dateAdded}" pattern="dd-MM-yyyy"/></span>
        <a class="btn btn-sm btn-outline-primary" href="<c:out value='${r.link}'/>" target="_blank" rel="noopener noreferrer">Open <i class="fa-solid fa-arrow-up-right-from-square"></i></a></div>
    </div></div></c:forEach></div></c:otherwise>
  </c:choose>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
