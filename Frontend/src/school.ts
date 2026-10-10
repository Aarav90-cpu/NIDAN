import './style.css';
import '@material/web/button/outlined-button.js';
import '@material/web/icon/icon.js';

interface SchoolStudent {
  id: string;
  name: string;
}

interface SchoolClass {
  id: string;
  name: string;
  grade: string;
  division: string;
  students: SchoolStudent[];
  studentCount: number;
  averageMarkPercent: number | null;
  openDoubtCount: number;
  pendingWorkCount: number;
  chapterCompletionPercent: number | null;
}

interface SchoolNotice {
  id: string;
  title: string;
  body: string;
  className: string | null;
  authorName: string;
  createdAt: string;
}

interface SchoolAssignment {
  id: string;
  className: string;
  title: string;
  instructions: string;
  subject: string;
  chapter: string | null;
  dueAt: string;
  studentCount: number;
  submittedCount: number;
  averageMarkPercent: number | null;
}

interface AssignmentSubmission {
  studentId: string;
  studentName: string;
  status: string;
  submittedAt: string | null;
  mark: number | null;
  maximumMark: number | null;
  teacherFeedback: string | null;
}

interface SchoolMark {
  studentName: string;
  className: string;
  subject: string;
  assessmentTitle: string;
  mark: number;
  maximumMark: number;
  recordedAt: string;
}

interface SchoolDoubt {
  id: string;
  studentName: string;
  className: string;
  subject: string;
  topic: string;
  message: string;
  status: string;
  createdAt: string;
}

interface SchoolChapter {
  className: string;
  subject: string;
  chapter: string;
  completionPercent: number;
  updatedAt: string;
}

interface SchoolDashboard {
  role: 'teacher' | 'vicePrincipal' | 'principal';
  name: string;
  classes: SchoolClass[];
  notices: SchoolNotice[];
  assignments: SchoolAssignment[];
  marks: SchoolMark[];
  doubts: SchoolDoubt[];
  chapters: SchoolChapter[];
  staff: { teacherName: string; classes: string[]; subjects: string[]; worksheetsCreated: number; chapterUpdates: number; marksRecorded: number }[];
}

const root = document.getElementById('app')!;
const workspace = root.dataset.workspace;
const classList = document.getElementById('class-list')!;
const assignmentList = document.getElementById('assignment-list')!;
const noticeList = document.getElementById('notice-list')!;
const markList = document.getElementById('mark-list')!;
const doubtList = document.getElementById('doubt-list')!;
const chapterList = document.getElementById('chapter-list')!;
const staffList = document.getElementById('staff-list');
const connectionState = document.getElementById('connection-state')!;
const greeting = document.getElementById('workspace-greeting')!;

function addText(parent: HTMLElement, tag: string, text: string, className?: string) {
  const element = document.createElement(tag);
  element.textContent = text;
  if (className) element.className = className;
  parent.appendChild(element);
  return element;
}

function clear(element: HTMLElement) {
  element.replaceChildren();
}

function emptyMessage(parent: HTMLElement, message: string) {
  addText(parent, 'p', message, 'school-meta');
}

async function requestJSON<T>(url: string, init?: RequestInit): Promise<T> {
  const response = await fetch(url, { credentials: 'same-origin', ...init });
  if (response.status === 401) {
    window.location.href = '/onboarding.html';
    throw new Error('Your session expired. Sign in again.');
  }
  if (!response.ok) {
    const error = await response.json().catch(() => ({}));
    throw new Error(error.reason || `Request failed (${response.status}).`);
  }
  if (response.status === 204) return undefined as T;
  return response.json() as Promise<T>;
}

function formatDate(value: string) {
  return new Intl.DateTimeFormat(undefined, { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value));
}

function renderClasses(classes: SchoolClass[]) {
  clear(classList);
  if (classes.length === 0) return emptyMessage(classList, 'No authorized classes are assigned to this account yet.');
  for (const schoolClass of classes) {
    const card = document.createElement('article');
    card.className = 'card class-card';
    addText(card, 'h3', `${schoolClass.name} · Grade ${schoolClass.grade}`);
    addText(card, 'p', `${schoolClass.studentCount} students · ${schoolClass.averageMarkPercent ?? 'No'}% average recorded marks`);
    addText(card, 'p', `${schoolClass.pendingWorkCount} worksheets pending · ${schoolClass.openDoubtCount} open doubts`);
    addText(card, 'p', `${schoolClass.chapterCompletionPercent ?? 'No'}% average chapter coverage`);
    const roster = document.createElement('ul');
    roster.className = 'class-roster';
    for (const student of schoolClass.students) addText(roster, 'li', student.name);
    card.appendChild(roster);
    classList.appendChild(card);
  }
}

function renderAssignments(assignments: SchoolAssignment[]) {
  clear(assignmentList);
  if (assignments.length === 0) return emptyMessage(assignmentList, 'No worksheets have been assigned to these classes.');
  for (const assignment of assignments) {
    const item = document.createElement('article');
    item.className = 'school-item';
    addText(item, 'h3', `${assignment.title} · ${assignment.className}`);
    addText(item, 'p', `${assignment.subject}${assignment.chapter ? ` · ${assignment.chapter}` : ''} · due ${formatDate(assignment.dueAt)}`);
    addText(item, 'p', `${assignment.submittedCount} of ${assignment.studentCount} submitted · ${assignment.averageMarkPercent === null ? 'Not marked' : `${assignment.averageMarkPercent}% class average`}`);
    addText(item, 'p', assignment.instructions);
    const submissionsButton = document.createElement('button');
    submissionsButton.type = 'button';
    submissionsButton.textContent = 'Review hand-ins';
    submissionsButton.dataset.assignmentId = assignment.id;
    item.appendChild(submissionsButton);
    assignmentList.appendChild(item);
  }
}

async function showAssignmentSubmissions(assignmentID: string, container: HTMLElement) {
  const oldView = container.querySelector('.assignment-submissions');
  oldView?.remove();
  const panel = document.createElement('div');
  panel.className = 'assignment-submissions';
  addText(panel, 'p', 'Loading submission list...', 'school-meta');
  container.appendChild(panel);
  try {
    const submissions = await requestJSON<AssignmentSubmission[]>(`/api/v1/assignments/${encodeURIComponent(assignmentID)}/submissions`);
    clear(panel);
    for (const submission of submissions) {
      const row = document.createElement('article');
      row.className = 'school-item';
      addText(row, 'h3', submission.studentName);
      addText(row, 'p', `${submission.status}${submission.submittedAt ? ` · handed in ${formatDate(submission.submittedAt)}` : ''}`);
      if (submission.status === 'submitted' && root.dataset.role !== 'vicePrincipal') {
        const form = document.createElement('form');
        form.className = 'school-form';
        const markInput = document.createElement('input');
        markInput.name = 'mark';
        markInput.type = 'number';
        markInput.min = '0';
        markInput.max = '1000';
        markInput.required = true;
        const maxInput = document.createElement('input');
        maxInput.name = 'maximumMark';
        maxInput.type = 'number';
        maxInput.min = '1';
        maxInput.max = '1000';
        maxInput.value = '20';
        maxInput.required = true;
        const feedback = document.createElement('input');
        feedback.name = 'feedback';
        feedback.maxLength = 2000;
        feedback.placeholder = 'Feedback (optional)';
        for (const [labelText, input] of [['Mark', markInput], ['Out of', maxInput], ['Feedback', feedback]] as const) {
          const label = document.createElement('label');
          label.append(labelText, input);
          form.appendChild(label);
        }
        const button = document.createElement('button');
        button.type = 'submit';
        button.textContent = 'Save mark';
        form.appendChild(button);
        const status = document.createElement('p');
        status.className = 'status-message form-wide';
        status.setAttribute('aria-live', 'polite');
        form.appendChild(status);
        form.addEventListener('submit', event => {
          event.preventDefault();
          const values = new FormData(form);
          void postForm(form, `/api/v1/assignments/${encodeURIComponent(assignmentID)}/marks`, {
            studentId: submission.studentId,
            mark: Number(values.get('mark')),
            maximumMark: Number(values.get('maximumMark')),
            feedback: values.get('feedback') || null
          });
        });
        row.appendChild(form);
      } else if (submission.status === 'marked') {
        addText(row, 'p', `${submission.mark}/${submission.maximumMark}${submission.teacherFeedback ? ` · ${submission.teacherFeedback}` : ''}`);
      }
      panel.appendChild(row);
    }
    if (submissions.length === 0) emptyMessage(panel, 'No students are enrolled in this class.');
  } catch (error) {
    clear(panel);
    emptyMessage(panel, error instanceof Error ? error.message : 'Could not load submissions.');
  }
}

function renderNotices(notices: SchoolNotice[]) {
  clear(noticeList);
  if (notices.length === 0) return emptyMessage(noticeList, 'No notices have been published.');
  for (const notice of notices) {
    const item = document.createElement('article');
    item.className = 'school-item';
    addText(item, 'h3', notice.title);
    addText(item, 'p', notice.body);
    addText(item, 'p', `${notice.className ?? 'Whole school'} · ${notice.authorName} · ${formatDate(notice.createdAt)}`, 'school-meta');
    noticeList.appendChild(item);
  }
}

function renderMarks(marks: SchoolMark[]) {
  clear(markList);
  if (marks.length === 0) return emptyMessage(markList, 'No school test marks have been recorded yet.');
  for (const mark of marks) {
    addText(markList, 'p', `${mark.studentName} · ${mark.className} · ${mark.subject}: ${mark.mark}/${mark.maximumMark} · ${mark.assessmentTitle} · ${formatDate(mark.recordedAt)}`, 'school-item');
  }
}

function renderDoubts(doubts: SchoolDoubt[]) {
  clear(doubtList);
  if (doubts.length === 0) return emptyMessage(doubtList, 'The doubt queue is clear.');
  for (const doubt of doubts) {
    const item = document.createElement('article');
    item.className = 'school-item';
    addText(item, 'h3', `${doubt.topic} · ${doubt.className}`);
    addText(item, 'p', `${doubt.studentName} · ${doubt.subject} · ${doubt.status}`);
    addText(item, 'p', doubt.message);
    if (doubt.status === 'open') {
      const form = document.createElement('form');
      form.className = 'school-form';
      form.dataset.doubtId = doubt.id;
      const label = document.createElement('label');
      label.className = 'form-wide';
      label.append('Teacher response');
      const input = document.createElement('textarea');
      input.name = 'message';
      input.required = true;
      input.maxLength = 2000;
      label.appendChild(input);
      form.appendChild(label);
      const button = document.createElement('button');
      button.type = 'submit';
      button.textContent = 'Send response';
      form.appendChild(button);
      const status = document.createElement('p');
      status.className = 'status-message form-wide';
      status.setAttribute('aria-live', 'polite');
      form.appendChild(status);
      item.appendChild(form);
    }
    doubtList.appendChild(item);
  }
}

function renderChapters(chapters: SchoolChapter[]) {
  clear(chapterList);
  if (chapters.length === 0) return emptyMessage(chapterList, 'No chapter coverage has been recorded.');
  for (const chapter of chapters) {
    addText(chapterList, 'p', `${chapter.className} · ${chapter.subject} · ${chapter.chapter}: ${chapter.completionPercent}% · updated ${formatDate(chapter.updatedAt)}`, 'school-item');
  }
}

function renderStaff(data: SchoolDashboard) {
  if (!staffList) return;
  clear(staffList);
  if (data.staff.length === 0) return emptyMessage(staffList, 'No teacher class assignments are recorded.');
  for (const teacher of data.staff) {
    const item = document.createElement('article');
    item.className = 'school-item';
    addText(item, 'h3', teacher.teacherName);
    addText(item, 'p', `Classes: ${teacher.classes.join(', ') || 'None'}`);
    addText(item, 'p', `Subjects: ${teacher.subjects.join(', ') || 'None'}`);
    addText(item, 'p', `${teacher.worksheetsCreated} worksheets created · ${teacher.chapterUpdates} chapter updates · ${teacher.marksRecorded} marks recorded`);
    staffList.appendChild(item);
  }
}

function fillSelect(select: HTMLSelectElement, classes: SchoolClass[], allowSchoolWide = false) {
  select.replaceChildren();
  if (allowSchoolWide) {
    const option = document.createElement('option');
    option.value = 'school-wide';
    option.textContent = 'Whole school';
    select.appendChild(option);
  }
  for (const schoolClass of classes) {
    const option = document.createElement('option');
    option.value = schoolClass.id;
    option.textContent = schoolClass.name;
    select.appendChild(option);
  }
}

function configureForms(data: SchoolDashboard) {
  for (const form of document.querySelectorAll<HTMLFormElement>('#assignment-form, #chapter-form')) {
    fillSelect(form.elements.namedItem('classId') as HTMLSelectElement, data.classes);
  }
  const noticeForm = document.getElementById('notice-form') as HTMLFormElement | null;
  if (noticeForm) fillSelect(noticeForm.elements.namedItem('classId') as HTMLSelectElement, data.classes, data.role === 'principal');
  const markForm = document.getElementById('mark-form') as HTMLFormElement | null;
  if (markForm) {
    const studentSelect = markForm.elements.namedItem('student') as HTMLSelectElement;
    studentSelect.replaceChildren();
    for (const schoolClass of data.classes) {
      for (const student of schoolClass.students) {
        const option = document.createElement('option');
        option.value = `${student.id}:${schoolClass.id}`;
        option.textContent = `${student.name} · ${schoolClass.name}`;
        studentSelect.appendChild(option);
      }
    }
  }
}

function formStatus(form: HTMLFormElement, message: string) {
  const output = form.querySelector('.status-message');
  if (output) output.textContent = message;
}

async function postForm<T>(form: HTMLFormElement, url: string, body: unknown) {
  const button = form.querySelector('button[type="submit"]') as HTMLButtonElement;
  button.disabled = true;
  formStatus(form, 'Saving...');
  try {
    await requestJSON<T>(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
    form.reset();
    formStatus(form, 'Saved to the school record.');
    await loadDashboard();
  } catch (error) {
    formStatus(form, error instanceof Error ? error.message : 'Could not save this record.');
  } finally {
    button.disabled = false;
  }
}

async function loadDashboard() {
  const data = await requestJSON<SchoolDashboard>('/api/v1/school/dashboard');
  const isTeacherWorkspace = workspace === 'teacher';
  const accountIsTeacher = data.role === 'teacher';
  if (isTeacherWorkspace !== accountIsTeacher) {
    const destination = data.role === 'teacher' ? '/teacher.html' : '/leadership.html';
    window.location.href = destination;
    return;
  }
  greeting.textContent = `${data.name} · ${data.classes.length} authorized classes`;
  root.dataset.role = data.role;
  connectionState.textContent = 'Local school server connected';
  connectionState.style.backgroundColor = '#e8f5e9';
  connectionState.style.color = '#1b5e20';
  renderClasses(data.classes);
  renderAssignments(data.assignments);
  renderNotices(data.notices);
  renderMarks(data.marks);
  renderDoubts(data.doubts);
  renderChapters(data.chapters);
  renderStaff(data);
  configureForms(data);
  if (data.role === 'vicePrincipal') {
    document.getElementById('assignment-form')?.closest('section')?.setAttribute('hidden', '');
    document.getElementById('chapter-form')?.closest('section')?.setAttribute('hidden', '');
    document.getElementById('provisioning-section')?.setAttribute('hidden', '');
  }
}

assignmentList.addEventListener('click', event => {
  const target = event.target;
  if (!(target instanceof HTMLButtonElement) || !target.dataset.assignmentId) return;
  const item = target.closest('.school-item');
  if (item) void showAssignmentSubmissions(target.dataset.assignmentId, item as HTMLElement);
});

(document.getElementById('assignment-form') as HTMLFormElement | null)?.addEventListener('submit', event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  void postForm(form, '/api/v1/assignments', {
    classId: values.get('classId'), title: values.get('title'), instructions: values.get('instructions'),
    subject: values.get('subject'), chapter: values.get('chapter') || null,
    dueAt: new Date(String(values.get('dueAt'))).toISOString()
  });
});

(document.getElementById('notice-form') as HTMLFormElement | null)?.addEventListener('submit', event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  void postForm(form, '/api/v1/notices', {
    classId: values.get('classId') === 'school-wide' ? null : values.get('classId'),
    title: values.get('title'), body: values.get('body')
  });
});

(document.getElementById('chapter-form') as HTMLFormElement | null)?.addEventListener('submit', event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  void postForm(form, '/api/v1/chapter-progress', {
    classId: values.get('classId'), subject: values.get('subject'), chapter: values.get('chapter'),
    completionPercent: Number(values.get('completionPercent'))
  });
});

(document.getElementById('mark-form') as HTMLFormElement | null)?.addEventListener('submit', event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  const [studentId, classId] = String(values.get('student')).split(':');
  void postForm(form, '/api/v1/marks', {
    studentId, classId, subject: values.get('subject'), assessmentTitle: values.get('assessmentTitle'),
    mark: Number(values.get('mark')), maximumMark: Number(values.get('maximumMark'))
  });
});

doubtList.addEventListener('submit', event => {
  const form = event.target;
  if (!(form instanceof HTMLFormElement) || !form.dataset.doubtId) return;
  event.preventDefault();
  const values = new FormData(form);
  void postForm(form, `/api/v1/doubts/${encodeURIComponent(form.dataset.doubtId)}/responses`, { message: values.get('message') });
});

const enrollmentForm = document.getElementById('enrollment-form') as HTMLFormElement | null;
const enrollmentRole = enrollmentForm?.elements.namedItem('role') as HTMLSelectElement | null;
function updateEnrollmentScopeFields() {
  if (!enrollmentRole) return;
  const leadership = enrollmentRole.value === 'principal' || enrollmentRole.value === 'vicePrincipal';
  const classes = document.getElementById('enrollment-classes-field');
  const subjects = document.getElementById('enrollment-subjects-field');
  if (classes) classes.hidden = leadership;
  if (subjects) subjects.hidden = leadership || enrollmentRole.value === 'student';
}
enrollmentRole?.addEventListener('change', updateEnrollmentScopeFields);
updateEnrollmentScopeFields();

enrollmentForm?.addEventListener('submit', event => {
  event.preventDefault();
  const form = event.currentTarget as HTMLFormElement;
  const values = new FormData(form);
  const role = String(values.get('role'));
  const classes = String(values.get('classes') || '').split(',').map(value => value.trim()).filter(Boolean);
  const subjects = String(values.get('subjects') || '').split(',').map(value => value.trim()).filter(Boolean);
  const codeBox = document.getElementById('issued-code')!;
  const issueCode = async () => {
    try {
      const result = await requestJSON<{ code: string; role: string; expiresAt: string }>('/api/v1/school/enrollment-codes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ role, classes, subjects })
      });
      codeBox.replaceChildren();
      codeBox.hidden = false;
      const heading = document.createElement('h3');
      heading.textContent = `One-time ${result.role} setup code`;
      const code = document.createElement('code');
      code.textContent = result.code;
      code.tabIndex = 0;
      code.style.cssText = 'display:block; padding:1rem; overflow-wrap:anywhere; background:#f0f4f4; user-select:all;';
      const expiry = document.createElement('p');
      expiry.textContent = `Expires ${formatDate(result.expiresAt)}. Give this code only to the intended person; it is shown only here.`;
      codeBox.append(heading, code, expiry);
      formStatus(form, 'Code issued. Record and deliver it securely.');
    } catch (error) {
      formStatus(form, error instanceof Error ? error.message : 'Could not issue a code.');
    } finally {
      const button = form.querySelector('button[type="submit"]') as HTMLButtonElement;
      button.disabled = false;
    }
  };
  const button = form.querySelector('button[type="submit"]') as HTMLButtonElement;
  button.disabled = true;
  formStatus(form, 'Issuing code...');
  void issueCode();
});

document.getElementById('logout-btn')?.addEventListener('click', async () => {
  try {
    await requestJSON<void>('/api/logout', { method: 'POST' });
    window.location.href = '/onboarding.html';
  } catch (error) {
    connectionState.textContent = error instanceof Error ? error.message : 'Sign out failed.';
  }
});

void loadDashboard().catch(error => {
  connectionState.textContent = error instanceof Error ? error.message : 'School server unavailable.';
  connectionState.style.backgroundColor = '#ffebee';
  connectionState.style.color = '#ba1a1a';
});
