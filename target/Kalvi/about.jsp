<% request.setAttribute("pageTitle", "About"); request.setAttribute("activeNav", "about"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<k:pageHead title="About Kalvi" subtitle="Kalvi (கல்வி) means education."/>
<div class="container section">
  <div class="row g-4">
    <div class="col-lg-7"><div class="k-card detail-block">
      <h2>Our purpose</h2>
      <p>Kalvi helps students who have completed 12th standard &ndash; especially in Tamil Nadu &ndash; to choose a course, understand career options and discover government examinations they may be eligible for.</p>
      <h2 class="mt-4">Data accuracy</h2>
      <p>Sample data in this installation is clearly labelled <span class="demo-pill">DEMO</span>. Exam dates, eligibility and fees change often, so every exam page shows its <strong>official source link</strong> and a <strong>last updated date</strong>. Administrators can replace demo information with verified details.</p>
    </div></div>
    <div class="col-lg-5"><div class="k-card detail-block">
      <h2>Built with</h2>
      <p class="mb-1">Java &bull; Servlets &bull; JSP &bull; JDBC &bull; MySQL</p>
      <p class="mb-1">MVC &bull; DAO &bull; Maven &bull; Apache Tomcat</p>
      <p class="mb-0">Bootstrap 5 &bull; Font Awesome &bull; Chart.js</p>
    </div></div>
  </div>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
