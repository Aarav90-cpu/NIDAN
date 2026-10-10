import './style.css';
import '@material/web/button/filled-button.js';
import '@material/web/icon/icon.js';

type OnboardingRole = 'student' | 'teacher' | 'vicePrincipal' | 'principal';
let selectedRole: OnboardingRole | null = null;
const step1 = document.getElementById('step-1')!;
const step2 = document.getElementById('step-2')!;
const nextBtn = document.getElementById('next-btn')! as any;

(window as any).selectRole = (role: OnboardingRole) => {
  selectedRole = role;
  document.querySelectorAll('.role-card').forEach(card => card.classList.remove('selected'));
  document.getElementById(`role-${role}`)?.classList.add('selected');
  nextBtn.disabled = false;
};

function renderStudentForm() {
  return `
    <h3 style="text-align: left; margin-bottom: 1rem;">Student Details</h3>
    ${renderEnrollmentCodeField()}
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
  `;
}

function renderTeacherForm() {
  return `
    <h3 style="text-align: left; margin-bottom: 1rem;">Teacher Details</h3>
    ${renderEnrollmentCodeField()}
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
  `;
}

function renderLeadershipForm(role: 'vicePrincipal' | 'principal') {
  const title = role === 'principal' ? 'Principal Details' : 'Vice-Principal Details';
  return `
    <h3 style="text-align: left; margin-bottom: 1rem;">${title}</h3>
    ${renderEnrollmentCodeField()}
    <div class="form-group">
      <label>Full Name</label>
      <input type="text" id="name" autocomplete="name" required>
    </div>
  `;
}

function renderEnrollmentCodeField() {
  return `
    <div class="form-group">
      <label for="enrollmentCode">School-issued enrollment code</label>
      <input type="password" id="enrollmentCode" autocomplete="one-time-code" required>
    </div>
  `;
}

function readList(id: string) {
  return (document.getElementById(id) as HTMLInputElement).value
    .split(',')
    .map(value => value.trim())
    .filter(Boolean);
}

let currentStep = 1;

nextBtn.addEventListener('click', async () => {
  if (currentStep === 1) {
    if (!selectedRole) return;
    step1.style.display = 'none';
    if (selectedRole === 'student') step2.innerHTML = renderStudentForm();
    else if (selectedRole === 'teacher') step2.innerHTML = renderTeacherForm();
    else step2.innerHTML = renderLeadershipForm(selectedRole);
    step2.classList.add('active');
    nextBtn.innerText = 'Complete Setup';
    currentStep = 2;
  } else if (currentStep === 2) {
    // Collect data and submit
    const payload: any = {
      role: selectedRole,
      name: (document.getElementById('name') as HTMLInputElement).value.trim(),
      enrollmentCode: (document.getElementById('enrollmentCode') as HTMLInputElement).value.trim()
    };
    
    if (selectedRole === 'student') {
      payload.studentClass = (document.getElementById('class') as HTMLInputElement).value;
      payload.division = (document.getElementById('div') as HTMLInputElement).value;
      payload.classTeacher = (document.getElementById('classTeacher') as HTMLInputElement).value;
      payload.englishTeacher = (document.getElementById('englishTeacher') as HTMLInputElement).value;
      payload.ictTeacher = (document.getElementById('ictTeacher') as HTMLInputElement).value;
    } else if (selectedRole === 'teacher') {
      payload.teacherRole = (document.getElementById('teacherRole') as HTMLSelectElement).value;
      payload.classTeacherOf = (document.getElementById('classTeacherOf') as HTMLInputElement).value;
      payload.subjectsTaught = readList('subjectsTaught');
      payload.classesTaught = readList('classesTaught');
    }
    
    nextBtn.disabled = true;
    nextBtn.innerText = 'Saving...';
    
    try {
      const res = await fetch('/api/onboarding', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      
      if (res.ok) {
        window.location.href = selectedRole === 'teacher' ? '/teacher.html' :
          selectedRole === 'student' ? '/' : '/leadership.html';
      } else {
        const error = await res.json().catch(() => ({}));
        alert(error.reason || 'Could not complete setup. Check the code and required details.');
        nextBtn.disabled = false;
        nextBtn.innerText = 'Complete Setup';
      }
    } catch (e) {
      alert('Network error connecting to NIDAN core.');
      nextBtn.disabled = false;
      nextBtn.innerText = 'Complete Setup';
    }
  }
});
