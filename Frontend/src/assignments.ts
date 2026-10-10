import './style.css';
import '@material/web/button/filled-button.js';
import '@material/web/button/outlined-button.js';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/list/list.js';
import '@material/web/list/list-item.js';
import '@material/web/divider/divider.js';

interface StudentAssignment {
  id: string;
  title: string;
  instructions: string;
  subject: string;
  chapter: string | null;
  dueAt: string;
  status: 'assigned' | 'submitted' | 'marked';
  mark: number | null;
  maximumMark: number | null;
  teacherFeedback: string | null;
}

interface StudentDashboard {
  name: string;
  classes: string[];
  assignments: StudentAssignment[];
  notices: { title: string; body: string; className: string | null; authorName: string; createdAt: string }[];
  marks: { className: string; subject: string; assessmentTitle: string; mark: number; maximumMark: number; recordedAt: string }[];
}

const list = document.getElementById('assignment-list')!;
const viewEmpty = document.getElementById('view-empty')!;
const viewActive = document.getElementById('view-active')!;
const activeTitle = document.getElementById('active-title')!;
const activeDue = document.getElementById('active-due')!;
const activeDescription = document.getElementById('active-description')!;
const submissionArea = document.getElementById('submission-area')!;
const resultArea = document.getElementById('result-area')!;
const submitButton = document.getElementById('submit-btn')! as any;
const resultTitle = document.getElementById('result-title')!;
const resultScore = document.getElementById('result-score')!;
const resultFeedback = document.getElementById('result-feedback')!;
const assignments: StudentAssignment[] = [];
let activeAssignment: StudentAssignment | null = null;

function displayDate(value: string) {
  return new Intl.DateTimeFormat(undefined, { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value));
}

function renderList() {
  list.replaceChildren();
  if (assignments.length === 0) {
    const empty = document.createElement('p');
    empty.textContent = 'No worksheets assigned.';
    list.appendChild(empty);
    return;
  }
  assignments.forEach((assignment, index) => {
    const item = document.createElement('md-list-item');
    item.setAttribute('type', 'button');
    const headline = document.createElement('span');
    headline.slot = 'headline';
    headline.textContent = assignment.title;
    const supporting = document.createElement('span');
    supporting.slot = 'supporting-text';
    supporting.textContent = `${assignment.status === 'assigned' ? 'Hand in at school' : assignment.status} · ${displayDate(assignment.dueAt)}`;
    item.append(headline, supporting);
    item.addEventListener('click', () => openAssignment(assignment));
    list.appendChild(item);
    if (index < assignments.length - 1) {
      const divider = document.createElement('md-divider');
      list.appendChild(divider);
    }
  });
}

function openAssignment(assignment: StudentAssignment) {
  activeAssignment = assignment;
  viewEmpty.style.display = 'none';
  viewActive.style.display = 'block';
  activeTitle.textContent = assignment.title;
  activeDue.textContent = `Due ${displayDate(assignment.dueAt)}`;
  activeDescription.textContent = `${assignment.subject}${assignment.chapter ? ` · ${assignment.chapter}` : ''}\n${assignment.instructions}`;
  submissionArea.style.display = assignment.status === 'assigned' ? 'block' : 'none';
  resultArea.style.display = assignment.status === 'assigned' ? 'none' : 'block';
  if (assignment.status !== 'assigned') {
    resultTitle.textContent = assignment.status === 'marked' ? 'Marked by your teacher' : 'Handed in at school';
    resultScore.textContent = assignment.mark !== null && assignment.maximumMark !== null ? `Mark: ${assignment.mark}/${assignment.maximumMark}` : 'Mark not yet entered';
    resultFeedback.textContent = assignment.teacherFeedback || 'Your teacher has not added feedback yet.';
  }
}

async function loadAssignments() {
  try {
    const response = await fetch('/api/v1/student/dashboard');
    if (response.status === 401) {
      window.location.href = '/onboarding.html';
      return;
    }
    if (!response.ok) throw new Error('Could not load your school assignments.');
    const dashboard = await response.json() as StudentDashboard;
    if (dashboard.assignments.length > 0 || assignments.length === 0) {
      assignments.splice(0, assignments.length, ...dashboard.assignments);
    }
    renderList();
    if (activeAssignment) {
      const refreshed = assignments.find(item => item.id === activeAssignment?.id);
      if (refreshed) openAssignment(refreshed);
    }
  } catch (error) {
    const empty = document.createElement('p');
    empty.textContent = error instanceof Error ? error.message : 'Assignments are unavailable.';
    list.replaceChildren(empty);
  }
}

submitButton.addEventListener('click', async () => {
  if (!activeAssignment) return;
  submitButton.disabled = true;
  try {
    const response = await fetch(`/api/v1/student/assignments/${encodeURIComponent(activeAssignment.id)}/submit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ completedInClass: true })
    });
    if (response.status === 401) {
      window.location.href = '/onboarding.html';
      return;
    }
    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new Error(error.reason || 'Could not record the hand-in.');
    }
    await loadAssignments();
  } catch (error) {
    resultArea.style.display = 'block';
    resultTitle.textContent = 'Not submitted';
    resultScore.textContent = '';
    resultFeedback.textContent = error instanceof Error ? error.message : 'Could not record the hand-in.';
  } finally {
    submitButton.disabled = false;
  }
});

void loadAssignments();
