import './style.css';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';

interface StudentDashboard {
  marks: { subject: string; assessmentTitle: string; mark: number; maximumMark: number; recordedAt: string }[];
}

const listEl = document.getElementById('progress-list')!;

async function loadProgress() {
  try {
    const response = await fetch('/api/v1/student/dashboard');
    if (response.status === 401) {
      window.location.href = '/onboarding.html';
      return;
    }
    if (!response.ok) throw new Error('School marks are unavailable.');
    const dashboard = await response.json() as StudentDashboard;
    listEl.replaceChildren();
    if (dashboard.marks.length === 0) {
      listEl.textContent = 'No school test marks have been recorded yet.';
      return;
    }
    for (const mark of dashboard.marks) {
      const item = document.createElement('article');
      item.className = 'progress-item';
      const title = document.createElement('h3');
      title.className = 'progress-title';
      title.textContent = `${mark.subject} · ${mark.assessmentTitle}`;
      const result = document.createElement('p');
      result.textContent = `${mark.mark}/${mark.maximumMark} · ${new Intl.DateTimeFormat(undefined, { dateStyle: 'medium' }).format(new Date(mark.recordedAt))}`;
      item.append(title, result);
      listEl.appendChild(item);
    }
  } catch (error) {
    listEl.textContent = error instanceof Error ? error.message : 'School marks are unavailable.';
  }
}

void loadProgress();
