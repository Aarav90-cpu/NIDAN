import"./icon-BclkLKie.js";import"./filled-button-CdBnqKPw.js";var e=null,t=document.getElementById(`step-1`),n=document.getElementById(`step-2`),r=document.getElementById(`next-btn`);window.selectRole=t=>{e=t,document.querySelectorAll(`.role-card`).forEach(e=>e.classList.remove(`selected`)),document.getElementById(`role-${t}`)?.classList.add(`selected`),r.disabled=!1};function i(){return`
    <h3 style="text-align: left; margin-bottom: 1rem;">Student Details</h3>
    ${s()}
    <div class="form-group">
      <label>Full Name</label>
      <input type="text" id="name" placeholder="Student name" autocomplete="name" required>
    </div>
    <div style="display: flex; gap: 1rem;">
      <div class="form-group" style="flex: 1;">
        <label>Class</label>
        <input type="text" id="class" placeholder="e.g. 9" required>
      </div>
      <div class="form-group" style="flex: 1;">
        <label>Division</label>
        <input type="text" id="div" placeholder="e.g. A" required>
      </div>
    </div>
    <div class="form-group">
      <label>Class Teacher</label>
      <input type="text" id="classTeacher" placeholder="Teacher Name">
    </div>
    <div class="form-group">
      <label>English Teacher</label>
      <input type="text" id="englishTeacher" placeholder="Teacher Name">
    </div>
    <div class="form-group">
      <label>ICT Teacher</label>
      <input type="text" id="ictTeacher" placeholder="Teacher Name">
    </div>
  `}function a(){return`
    <h3 style="text-align: left; margin-bottom: 1rem;">Teacher Details</h3>
    ${s()}
    <div class="form-group">
      <label>Full Name</label>
      <input type="text" id="name" placeholder="e.g. Mr. Sharma" required>
    </div>
    <div class="form-group">
      <label>Role</label>
      <select id="teacherRole">
        <option value="Class Teacher">Class Teacher</option>
        <option value="Supportive Teacher">Supportive Teacher</option>
      </select>
    </div>
    <div class="form-group">
      <label>Class Teacher Of (Optional)</label>
      <input type="text" id="classTeacherOf" placeholder="e.g. 9A">
    </div>
    <div class="form-group">
      <label>Subjects Taught</label>
      <input type="text" id="subjectsTaught" placeholder="e.g. English, ICT" required>
    </div>
    <div class="form-group">
      <label>Teaching Classes</label>
      <input type="text" id="classesTaught" placeholder="e.g. 9A, 9B" required>
    </div>
  `}function o(e){return`
    <h3 style="text-align: left; margin-bottom: 1rem;">${e===`principal`?`Principal Details`:`Vice-Principal Details`}</h3>
    ${s()}
    <div class="form-group">
      <label>Full Name</label>
      <input type="text" id="name" autocomplete="name" required>
    </div>
  `}function s(){return`
    <div class="form-group">
      <label for="enrollmentCode">School-issued enrollment code</label>
      <input type="password" id="enrollmentCode" autocomplete="one-time-code" required>
    </div>
  `}function c(e){return document.getElementById(e).value.split(`,`).map(e=>e.trim()).filter(Boolean)}var l=1;r.addEventListener(`click`,async()=>{if(l===1){if(!e)return;t.style.display=`none`,n.innerHTML=e===`student`?i():e===`teacher`?a():o(e),n.classList.add(`active`),r.innerText=`Complete Setup`,l=2}else if(l===2){let t={role:e,name:document.getElementById(`name`).value.trim(),enrollmentCode:document.getElementById(`enrollmentCode`).value.trim()};e===`student`?(t.studentClass=document.getElementById(`class`).value,t.division=document.getElementById(`div`).value,t.classTeacher=document.getElementById(`classTeacher`).value,t.englishTeacher=document.getElementById(`englishTeacher`).value,t.ictTeacher=document.getElementById(`ictTeacher`).value):e===`teacher`&&(t.teacherRole=document.getElementById(`teacherRole`).value,t.classTeacherOf=document.getElementById(`classTeacherOf`).value,t.subjectsTaught=c(`subjectsTaught`),t.classesTaught=c(`classesTaught`)),r.disabled=!0,r.innerText=`Saving...`;try{let n=await fetch(`/api/onboarding`,{method:`POST`,headers:{"Content-Type":`application/json`},body:JSON.stringify(t)});if(n.ok)window.location.href=e===`teacher`?`/teacher.html`:e===`student`?`/`:`/leadership.html`;else{let e=await n.json().catch(()=>({}));alert(e.reason||`Could not complete setup. Check the code and required details.`),r.disabled=!1,r.innerText=`Complete Setup`}}catch{alert(`Network error connecting to NIDAN core.`),r.disabled=!1,r.innerText=`Complete Setup`}}});