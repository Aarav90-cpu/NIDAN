import './style.css';

// Import Material Web Components
import '@material/web/button/filled-button.js';
import '@material/web/button/outlined-button.js';
import '@material/web/button/text-button.js';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/progress/linear-progress.js';
import '@material/web/list/list.js';
import '@material/web/list/list-item.js';
import '@material/web/divider/divider.js';
import '@material/web/checkbox/checkbox.js';
import '@material/web/labs/badge/badge.js';
import '@material/web/dialog/dialog.js';
import { MdDialog } from '@material/web/dialog/dialog.js';
import '@material/web/textfield/outlined-text-field.js';
import '@material/web/select/outlined-select.js';
import '@material/web/select/select-option.js';

// Logic for fetching status from the local Vapor backend
async function checkRegistration() {
  try {
    const res = await fetch('/api/me');
    if (res.status === 401 || res.status === 404) {
      window.location.href = '/onboarding.html';
    } else if (res.ok) {
      const user = await res.json();
      if (user.role === 'teacher' && window.location.pathname === '/') {
        window.location.href = '/teacher.html';
      } else if ((user.role === 'principal' || user.role === 'vicePrincipal') && window.location.pathname === '/') {
        window.location.href = '/leadership.html';
      } else if (user.role === 'student') {
        void loadStudentSchoolData();
      }
    }
  } catch (e) {
    console.error("Core offline, bypassing auth check");
  }
}

interface StudentSchoolData {
  name: string;
  classes: { id: string; name: string }[];
  assignments: { id: string; title: string; dueAt: string; status: string }[];
  notices: { title: string; body: string; className: string | null; authorName: string }[];
  marks: { subject: string; assessmentTitle: string; mark: number; maximumMark: number }[];
  doubts: { className: string; subject: string; topic: string; message: string; status: string; responseMessage: string | null; responseTeacherName: string | null }[];
  diagnosticAttemptCount: number;
  latestDiagnosticScore: number | null;
}

async function loadStudentSchoolData() {
  const card = document.getElementById('school-record-card');
  if (!card) return;
  try {
    const response = await fetch('/api/v1/student/dashboard');
    if (!response.ok) throw new Error('School records are currently unavailable.');
    const data = await response.json() as StudentSchoolData;
    const greetingText = document.getElementById('greeting-text');
    if (greetingText) greetingText.textContent = `Welcome, ${data.name}`;
    const classes = document.getElementById('student-class-list');
    if (classes) classes.textContent = data.classes.length ? `Your class${data.classes.length === 1 ? '' : 'es'}: ${data.classes.map(schoolClass => schoolClass.name).join(', ')}` : 'No class has been assigned yet.';

    const assignmentList = document.getElementById('student-assignment-list');
    const assignmentCount = document.getElementById('assignment-count');
    if (assignmentList) {
      assignmentList.replaceChildren();
      const pending = data.assignments.filter(assignment => assignment.status === 'assigned');
      if (assignmentCount) assignmentCount.setAttribute('value', String(pending.length));
      for (const assignment of pending.slice(0, 5)) {
        const item = document.createElement('md-list-item');
        item.setAttribute('type', 'button');
        item.addEventListener('click', () => { window.location.href = '/assignments.html'; });
        const title = document.createElement('span');
        title.slot = 'headline';
        title.textContent = assignment.title;
        const due = document.createElement('span');
        due.slot = 'supporting-text';
        due.textContent = `Due ${new Intl.DateTimeFormat(undefined, { dateStyle: 'medium' }).format(new Date(assignment.dueAt))} · hand in at school`;
        item.append(title, due);
        assignmentList.appendChild(item);
      }
      if (pending.length === 0) assignmentList.textContent = 'No worksheets currently assigned.';
    }
    const latestScore = document.getElementById('latest-diagnostic-score');
    if (latestScore) latestScore.textContent = data.latestDiagnosticScore === null ? '--' : `${data.latestDiagnosticScore}%`;
    const attemptCount = document.getElementById('diagnostic-attempt-count');
    if (attemptCount) attemptCount.textContent = String(data.diagnosticAttemptCount);

    const notices = document.getElementById('student-notices');
    if (notices) {
      notices.replaceChildren();
      for (const notice of data.notices) {
        const item = document.createElement('article');
        item.className = 'school-item';
        const title = document.createElement('h3');
        title.textContent = notice.title;
        const body = document.createElement('p');
        body.textContent = notice.body;
        const attribution = document.createElement('p');
        attribution.textContent = `${notice.className ?? 'Whole school'} · ${notice.authorName}`;
        item.append(title, body, attribution);
        notices.appendChild(item);
      }
      if (data.notices.length === 0) notices.textContent = 'No new school notices.';
    }

    const marks = document.getElementById('student-marks');
    if (marks) {
      marks.replaceChildren();
      for (const mark of data.marks) {
        const line = document.createElement('p');
        line.className = 'school-item';
        line.textContent = `${mark.subject} · ${mark.assessmentTitle}: ${mark.mark}/${mark.maximumMark}`;
        marks.appendChild(line);
      }
      if (data.marks.length === 0) marks.textContent = 'No school test marks recorded yet.';
    }

    const doubts = document.getElementById('student-doubts');
    if (doubts) {
      doubts.replaceChildren();
      for (const doubt of data.doubts) {
        const item = document.createElement('article');
        item.className = 'school-item';
        const title = document.createElement('h3');
        title.textContent = `${doubt.topic} · ${doubt.className} · ${doubt.status}`;
        const question = document.createElement('p');
        question.textContent = `${doubt.subject}: ${doubt.message}`;
        item.append(title, question);
        if (doubt.responseMessage) {
          const response = document.createElement('p');
          response.textContent = `${doubt.responseTeacherName ?? 'Teacher'} replied: ${doubt.responseMessage}`;
          item.appendChild(response);
        }
        doubts.appendChild(item);
      }
      if (data.doubts.length === 0) doubts.textContent = 'You have not sent a question yet.';
    }

    const classSelect = document.querySelector<HTMLElement>('#student-doubt-form md-outlined-select[name="classId"]');
    if (classSelect) {
      classSelect.replaceChildren();
      for (const schoolClass of data.classes) {
        const option = document.createElement('md-select-option');
        option.setAttribute('value', schoolClass.id);
        const headline = document.createElement('div');
        headline.slot = 'headline';
        headline.textContent = schoolClass.name;
        option.appendChild(headline);
        classSelect.appendChild(option);
      }
    }
  } catch (error) {
    const classes = document.getElementById('student-class-list');
    if (classes) classes.textContent = error instanceof Error ? error.message : 'School records are unavailable.';
  }
}

document.getElementById('student-doubt-form')?.addEventListener('submit', async event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  const status = form.querySelector('.status-message');
  const button = form.querySelector('[type="submit"]') as HTMLElement & { disabled: boolean };
  if (status) status.textContent = 'Sending...';
  button.disabled = true;
  try {
    const response = await fetch('/api/v1/student/doubts', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ classId: values.get('classId'), subject: values.get('subject'), topic: values.get('topic'), message: values.get('message') })
    });
    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new Error(error.reason || 'Could not send this question.');
    }
    form.reset();
    if (status) status.textContent = 'Sent to the teachers assigned to this class and subject.';
    void loadStudentSchoolData();
  } catch (error) {
    if (status) status.textContent = error instanceof Error ? error.message : 'Could not send this question.';
  } finally {
    button.disabled = false;
  }
});

async function checkBackendStatus() {
  const offlineIndicator = document.getElementById('offline-indicator');
  
  if (!offlineIndicator) return;

  try {
    const response = await fetch('/api/status');
    if (response.ok) {
      const text = await response.text();
      console.log('Backend connected:', text);
      
      // Update UI for online status
      offlineIndicator.style.backgroundColor = '#e8f5e9';
      offlineIndicator.style.color = '#1b5e20';
      offlineIndicator.innerHTML = '<span class="material-symbols-outlined">cloud_done</span> Local Backend Online';
    } else {
      throw new Error('Backend responded with error');
    }
  } catch (err) {
    console.warn('Backend is unreachable:', err);
    offlineIndicator.style.backgroundColor = '#ffebee';
    offlineIndicator.style.color = '#ba1a1a';
    offlineIndicator.innerHTML = '<span class="material-symbols-outlined">cloud_off</span> Local server unavailable';
  }
}

// Set up the current date display
function updateDate() {
  const dateElement = document.getElementById('date-text');
  if (dateElement) {
    const options: Intl.DateTimeFormatOptions = { weekday: 'long', month: 'long', day: 'numeric' };
    dateElement.textContent = `Ready to continue learning on ${new Date().toLocaleDateString(undefined, options)}?`;
  }
}

// Setup Interactive Elements
function setupInteractions() {
  const dialog = document.getElementById('action-dialog') as MdDialog;
  const dialogContent = document.getElementById('dialog-content');
  const dialogHeadline = document.getElementById('dialog-headline');

  if (!dialog || !dialogContent || !dialogHeadline) return;

  // Add listeners to standard action buttons
  document.querySelectorAll('.action-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const message = btn.getAttribute('data-message') || 'Action triggered!';
      dialogHeadline.textContent = 'Action Received';
      dialogContent.textContent = message;
      dialog.show();
    });
  });

  // Add listeners to task items (to toggle checkboxes)
  document.querySelectorAll('.task-item').forEach(item => {
    item.addEventListener('click', () => {
      const checkbox = item.querySelector('md-checkbox');
      if (checkbox) {
        checkbox.checked = !checkbox.checked;
        if (checkbox.checked) {
          const taskName = item.querySelector('[slot="headline"]')?.textContent || 'Task';
          dialogHeadline.textContent = 'Task Completed!';
          dialogContent.textContent = `Great job! You marked "${taskName}" as done.`;
          dialog.show();
        }
      }
    });
  });
}

// Initialize
updateDate();
checkRegistration();
checkBackendStatus();
setupInteractions();

// Polling for backend status
setInterval(checkBackendStatus, 10000);
