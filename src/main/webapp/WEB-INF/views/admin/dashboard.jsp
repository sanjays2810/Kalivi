<% request.setAttribute("pageTitle", "Dashboard"); request.setAttribute("activeAdmin", "dashboard"); %>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>
<div class="row g-3 mb-4">
  <div class="col-6 col-xl-3"><div class="k-card stat"><div class="ico"><i class="fa-solid fa-user-graduate"></i></div><div><div class="num">${totalStudents}</div><div class="lbl">Total Students</div></div></div></div>
  <div class="col-6 col-xl-3"><div class="k-card stat green"><div class="ico"><i class="fa-solid fa-book"></i></div><div><div class="num">${totalCourses}</div><div class="lbl">Total Courses</div></div></div></div>
  <div class="col-6 col-xl-3"><div class="k-card stat gold"><div class="ico"><i class="fa-solid fa-landmark"></i></div><div><div class="num">${totalExams}</div><div class="lbl">Government Exams</div></div></div></div>
  <div class="col-6 col-xl-3"><div class="k-card stat"><div class="ico"><i class="fa-solid fa-link"></i></div><div><div class="num">${totalResources}</div><div class="lbl">Total Resources</div></div></div></div>
</div>
<div class="row g-3">
  <div class="col-lg-4"><div class="k-card p-3"><h2 class="h6">Students by 12th group</h2><div class="chart-box"><canvas id="c1"></canvas></div></div></div>
  <div class="col-lg-4"><div class="k-card p-3"><h2 class="h6">Course categories</h2><div class="chart-box"><canvas id="c2"></canvas></div></div></div>
  <div class="col-lg-4"><div class="k-card p-3"><h2 class="h6">Exam categories</h2><div class="chart-box"><canvas id="c3"></canvas></div></div></div>
</div>
<div class="k-card p-3 mt-3 d-flex flex-wrap gap-2 align-items-center"><strong class="me-2">Quick actions:</strong>
  <a class="btn btn-sm btn-primary" href="${ctx}/admin/courses?action=new"><i class="fa-solid fa-plus me-1"></i>Add course</a>
  <a class="btn btn-sm btn-primary" href="${ctx}/admin/exams?action=new"><i class="fa-solid fa-plus me-1"></i>Add exam</a>
  <a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/resources?action=new">Add resource</a>
  <a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/libraries?action=new">Add library</a>
  <a class="btn btn-sm btn-outline-primary" href="${ctx}/admin/notifications?action=new">Post notification</a></div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
  var colors=['#2b2a86','#1f9d6b','#f5b82e','#4340c4','#e5604d','#6a6f8c','#17a2b8','#9b59b6'];
  function draw(id,type,labels,data){ new Chart(document.getElementById(id),{type:type,data:{labels:labels,datasets:[{data:data,backgroundColor:colors,borderWidth:0}]},
    options:{maintainAspectRatio:false,plugins:{legend:{display:type!=='bar',position:'bottom'}},scales:type==='bar'?{y:{beginAtZero:true,ticks:{precision:0}},x:{}}:{}}}); }
  draw('c1','doughnut',[<c:forEach items="${byGroup}" var="e" varStatus="s">"<c:out value='${e.key}'/>"${s.last ? '' : ','}</c:forEach>],[<c:forEach items="${byGroup}" var="e" varStatus="s">${e.value}${s.last ? '' : ','}</c:forEach>]);
  draw('c2','bar',[<c:forEach items="${byCategory}" var="e" varStatus="s">"<c:out value='${e.key}'/>"${s.last ? '' : ','}</c:forEach>],[<c:forEach items="${byCategory}" var="e" varStatus="s">${e.value}${s.last ? '' : ','}</c:forEach>]);
  draw('c3','pie',[<c:forEach items="${byExamCategory}" var="e" varStatus="s">"<c:out value='${e.key}'/>"${s.last ? '' : ','}</c:forEach>],[<c:forEach items="${byExamCategory}" var="e" varStatus="s">${e.value}${s.last ? '' : ','}</c:forEach>]);
</script>
<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
