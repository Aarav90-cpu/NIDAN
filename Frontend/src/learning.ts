import './style.css';
import '@material/web/button/filled-button.js';
import '@material/web/button/outlined-button.js';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/progress/linear-progress.js';
import '@material/web/radio/radio.js';
import { MdLinearProgress } from '@material/web/progress/linear-progress.js';
import { MdFilledButton } from '@material/web/button/filled-button.js';

// Elements
const viewLesson = document.getElementById('view-lesson')!;
const viewExercise = document.getElementById('view-exercise')!;
const viewCompletion = document.getElementById('view-completion')!;

const nextToExerciseBtn = document.getElementById('next-to-exercise-btn')!;
const hintBtn = document.getElementById('hint-btn')!;
const hintBox = document.getElementById('hint-box')!;
const optionsContainer = document.getElementById('options-container')!;
const submitBtn = document.getElementById('submit-btn') as MdFilledButton;
const retryBtn = document.getElementById('retry-btn') as HTMLElement;
const nextLessonBtn = document.getElementById('next-lesson-btn') as HTMLElement;

const feedbackBox = document.getElementById('feedback-box')!;
const feedbackTitle = document.getElementById('feedback-title')!;
const feedbackText = document.getElementById('feedback-text')!;
const progressBar = document.getElementById('learning-progress') as MdLinearProgress;
const challengeBtn = document.getElementById('challenge-btn')!;

// State
const correctAnswer = '3/8';
let selectedAnswer: string | null = null;
let challengeMode = false;

const options = ['1/8', '3/8', '5/8', '8/3'];

// Functions
function showView(view: HTMLElement) {
  viewLesson.style.display = 'none';
  viewExercise.style.display = 'none';
  viewCompletion.style.display = 'none';
  view.style.display = 'block';
  view.style.animation = 'none';
  view.offsetHeight; // trigger reflow
  view.style.animation = 'scaleUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both';
}

function renderOptions() {
  optionsContainer.innerHTML = '';
  options.forEach((opt) => {
    const optionDiv = document.createElement('div');
    optionDiv.className = 'option-item card';
    optionDiv.innerHTML = `
      <label style="display: flex; align-items: center; gap: 1rem; cursor: pointer; width: 100%;">
        <md-radio name="exercise-q" value="${opt}"></md-radio>
        <span style="font-size: 1.1rem; font-weight: 500;">${opt}</span>
      </label>
    `;
    
    const radio = optionDiv.querySelector('md-radio') as any;
    radio.addEventListener('change', () => {
      selectedAnswer = opt;
      submitBtn.disabled = false;
      document.querySelectorAll('.option-item').forEach(el => el.classList.remove('selected'));
      optionDiv.classList.add('selected');
    });

    optionsContainer.appendChild(optionDiv);
  });
}

// Event Listeners
nextToExerciseBtn.addEventListener('click', () => {
  showView(viewExercise);
  progressBar.value = 0.5;
  renderOptions();
});

hintBtn.addEventListener('click', () => {
  hintBox.style.display = 'block';
});

challengeBtn.addEventListener('click', () => {
  challengeMode = !challengeMode;
  if(challengeMode) {
     challengeBtn.style.backgroundColor = 'rgba(255, 87, 34, 0.1)';
     challengeBtn.style.color = '#e64a19';
     alert("Challenge Mode Enabled: Questions will be harder, and hints are disabled!");
     hintBtn.style.display = 'none';
  } else {
     challengeBtn.style.backgroundColor = 'transparent';
     challengeBtn.style.color = 'inherit';
     hintBtn.style.display = 'inline-flex';
  }
});

submitBtn.addEventListener('click', () => {
  submitBtn.style.display = 'none';
  feedbackBox.style.display = 'block';

  if (selectedAnswer === correctAnswer) {
    // Success
    feedbackBox.style.backgroundColor = '#e8f5e9';
    feedbackBox.style.borderLeft = '4px solid #4caf50';
    feedbackTitle.textContent = 'Correct!';
    feedbackTitle.style.color = '#2e7d32';
    feedbackText.textContent = 'You ate 3 out of the 8 total slices, which perfectly represents the fraction 3/8.';
    
    nextLessonBtn.style.display = 'block';
    retryBtn.style.display = 'none';
    progressBar.value = 0.75;
  } else {
    // Incorrect
    feedbackBox.style.backgroundColor = '#ffebee';
    feedbackBox.style.borderLeft = '4px solid #f44336';
    feedbackTitle.textContent = 'Not quite right.';
    feedbackTitle.style.color = '#c62828';
    
    let explanation = 'Remember: The top number (numerator) is how many parts you have, and the bottom number (denominator) is the total number of equal parts.';
    if(selectedAnswer === '8/3') explanation = 'You have it backwards! The denominator (total slices) goes on the bottom.';
    
    feedbackText.textContent = explanation;
    
    retryBtn.style.display = 'block';
  }
});

retryBtn.addEventListener('click', () => {
  // Reset for retry
  feedbackBox.style.display = 'none';
  retryBtn.style.display = 'none';
  submitBtn.style.display = 'block';
  submitBtn.disabled = true;
  selectedAnswer = null;
  renderOptions();
});

nextLessonBtn.addEventListener('click', () => {
  progressBar.value = 1.0;
  showView(viewCompletion);
});
