<% request.setAttribute("pageTitle", "Home"); request.setAttribute("activeNav", "home"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<section class="hero">
  <div class="container"><div class="row align-items-center gy-4">
    <div class="col-lg-6">
      <span class="badge-soft mb-3"><i class="fa-solid fa-location-dot"></i><fmt:message key="hero.badge"/></span>
      <h1 class="mb-3"><fmt:message key="hero.title"/></h1>
      <p class="lead mb-4"><fmt:message key="hero.subtitle"/></p>
      <div class="d-flex flex-wrap gap-2">
        <a class="btn btn-primary btn-lg" href="${ctx}/courses"><i class="fa-solid fa-compass me-2"></i><fmt:message key="hero.btn.courses"/></a>
        <a class="btn btn-outline-primary btn-lg" href="${ctx}/roadmap"><i class="fa-solid fa-route me-2"></i><fmt:message key="hero.btn.roadmap"/></a>
      </div>
    </div>
    <div class="col-lg-6 text-center"><img class="hero-img" src="${ctx}/images/hero.svg" alt="Road from 12th standard to career"></div>
  </div></div>
</section>

<section class="section">
  <div class="container">
    <h2 class="section-title text-center mb-4"><fmt:message key="quick.title"/></h2>
    <div class="row g-3 row-cols-1 row-cols-sm-2 row-cols-lg-5">
      <div class="col"><a class="k-card hoverable quick-card" href="${ctx}/courses"><div class="ico"><i class="fa-solid fa-book-open"></i></div><h3><fmt:message key="quick.courses"/></h3><p><fmt:message key="quick.courses.desc"/></p></a></div>
      <div class="col"><a class="k-card hoverable quick-card" href="${ctx}/exams"><div class="ico" style="background:var(--k-green-soft);color:var(--k-green)"><i class="fa-solid fa-landmark"></i></div><h3><fmt:message key="quick.exams"/></h3><p><fmt:message key="quick.exams.desc"/></p></a></div>
      <div class="col"><a class="k-card hoverable quick-card" href="${ctx}/roadmap"><div class="ico"><i class="fa-solid fa-route"></i></div><h3><fmt:message key="quick.roadmap"/></h3><p><fmt:message key="quick.roadmap.desc"/></p></a></div>
      <div class="col"><a class="k-card hoverable quick-card" href="${ctx}/exams#upcoming"><div class="ico" style="background:#fff1cc;color:#8a5a00"><i class="fa-solid fa-bell"></i></div><h3><fmt:message key="quick.notify"/></h3><p><fmt:message key="quick.notify.desc"/></p></a></div>
      <div class="col"><a class="k-card hoverable quick-card" href="${ctx}/libraries"><div class="ico" style="background:var(--k-green-soft);color:var(--k-green)"><i class="fa-solid fa-building-columns"></i></div><h3><fmt:message key="quick.nearby"/></h3><p><fmt:message key="quick.nearby.desc"/></p></a></div>
    </div>
  </div>
</section>

<section class="section pt-0">
  <div class="container text-center">
    <h2 class="section-title mb-4"><fmt:message key="flow.title"/></h2>
    <div class="flow">
      <span class="node"><i class="fa-solid fa-school me-1"></i>Education</span><i class="fa-solid fa-arrow-right arrow"></i>
      <span class="node"><i class="fa-solid fa-compass me-1"></i>Guidance</span><i class="fa-solid fa-arrow-right arrow"></i>
      <span class="node"><i class="fa-solid fa-briefcase me-1"></i>Career</span><i class="fa-solid fa-arrow-right arrow"></i>
      <span class="node"><i class="fa-solid fa-landmark me-1"></i>Government Opportunities</span><i class="fa-solid fa-arrow-right arrow"></i>
      <span class="node"><i class="fa-solid fa-star me-1"></i>Future</span>
    </div>
    <p class="text-muted mt-4 mb-0">Register once, enter your 12th details, and Kalvi recommends courses, eligible government exams and a printable roadmap.</p>
    <c:if test="${empty sessionScope.user}"><a class="btn btn-primary mt-3" href="${ctx}/register">Create free account</a></c:if>
  </div>
</section>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
