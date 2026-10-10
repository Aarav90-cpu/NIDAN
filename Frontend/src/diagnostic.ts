import './style.css';
import '@material/web/button/filled-button.js';
import '@material/web/button/outlined-button.js';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/progress/linear-progress.js';
import '@material/web/radio/radio.js';
import { MdLinearProgress } from '@material/web/progress/linear-progress.js';

interface Question {
  id: string;
  text: string;
  options: string[];
}

let questions: Question[] = [];
const answers: { questionId: string; answer: string }[] = [];
let currentQuestionIndex = 0;
let selectedAnswer: string | null = null;

const viewIntro = document.getElementById('view-intro')!;
const viewQuestion = document.getElementById('view-question')!;
const viewResults = document.getElementById('view-results')!;
const progressContainer = document.getElementById('progress-container')!;
const progressBar = document.getElementById('diagnostic-progress') as MdLinearProgress;
const questionText = document.getElementById('question-text')!;
const optionsContainer = document.getElementById('options-container')!;
const nextBtn = document.getElementById('next-btn') as any; // MdFilledButton
const startBtn = document.getElementById('start-btn')! as any;
const progressText = document.getElementById('progress-text')!;
const diagnosticState = document.getElementById('diagnostic-state')!;
const diagnosticScore = document.getElementById('diagnostic-score')!;
const diagnosticRecommendation = document.getElementById('diagnostic-recommendation')!;

function showView(view: HTMLElement) {
  viewIntro.style.display = 'none';
  viewQuestion.style.display = 'none';
  viewResults.style.display = 'none';
  view.style.display = 'block';
  // Add a small animation effect
  view.style.animation = 'none';
  view.offsetHeight; // trigger reflow
  view.style.animation = 'scaleUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both';
}

function renderQuestion() {
  const q = questions[currentQuestionIndex];
  questionText.textContent = q.text;
  optionsContainer.innerHTML = '';
  selectedAnswer = null;
  nextBtn.disabled = true;
  nextBtn.textContent = currentQuestionIndex === questions.length - 1 ? 'Submit Diagnostic' : 'Next Question';

  q.options.forEach((option) => {
    const optionDiv = document.createElement('div');
    optionDiv.className = 'option-item card';
    const label = document.createElement('label');
    label.style.cssText = 'display: flex; align-items: center; gap: 1rem; cursor: pointer; width: 100%;';
    const radio = document.createElement('md-radio') as any;
    radio.setAttribute('name', 'diagnostic-q');
    radio.setAttribute('value', option);
    const optionText = document.createElement('span');
    optionText.style.cssText = 'font-size: 1.1rem; font-weight: 500;';
    optionText.textContent = option;
    label.append(radio, optionText);
    optionDiv.appendChild(label);

    radio.addEventListener('change', () => {
      selectedAnswer = option;
      nextBtn.disabled = false;
      document.querySelectorAll('.option-item').forEach(el => el.classList.remove('selected'));
      optionDiv.classList.add('selected');
    });

    optionsContainer.appendChild(optionDiv);
  });

  const progress = currentQuestionIndex / questions.length;
  progressBar.value = progress;
  progressText.textContent = `Question ${currentQuestionIndex + 1} of ${questions.length}`;
}

async function startAssessment() {
  startBtn.disabled = true;
  progressText.textContent = 'Loading questions...';
  try {
    const response = await fetch('/api/diagnostic/questions');
    if (response.status === 401) {
      window.location.href = '/onboarding.html';
      return;
    }
    if (!response.ok) throw new Error('The diagnostic questions could not be loaded.');
    questions = await response.json();
    if (questions.length === 0) throw new Error('No diagnostic questions are available.');
    progressContainer.style.display = 'block';
    showView(viewQuestion);
    renderQuestion();
  } catch (error) {
    progressText.textContent = error instanceof Error ? error.message : 'The diagnostic could not be loaded.';
    startBtn.disabled = false;
  }
}

async function submitAttempt() {
  nextBtn.disabled = true;
  nextBtn.textContent = 'Saving...';
  try {
    const response = await fetch('/api/diagnostic/attempts', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ answers })
    });
    if (response.status === 401) {
      window.location.href = '/onboarding.html';
      return;
    }
    if (!response.ok) throw new Error('Your answers could not be saved. Try submitting again.');

    const result = await response.json();
    diagnosticState.textContent = result.state;
    diagnosticScore.textContent = `${result.score}% (${result.correctCount} of ${result.questionCount} correct)`;
    diagnosticRecommendation.textContent = result.recommendation;
    progressText.textContent = 'Diagnostic saved';
    progressBar.value = 1;
    progressContainer.style.display = 'none';
    showView(viewResults);
  } catch (error) {
    progressText.textContent = error instanceof Error ? error.message : 'Your answers could not be saved.';
    nextBtn.disabled = false;
    nextBtn.textContent = 'Retry Submission';
  }
}

startBtn.addEventListener('click', startAssessment);

nextBtn.addEventListener('click', () => {
  if (currentQuestionIndex < questions.length) {
    if (!selectedAnswer) return;
    answers.push({ questionId: questions[currentQuestionIndex].id, answer: selectedAnswer });
    currentQuestionIndex++;
  }
  if (currentQuestionIndex < questions.length) {
    renderQuestion();
  } else {
    void submitAttempt();
  }
});
