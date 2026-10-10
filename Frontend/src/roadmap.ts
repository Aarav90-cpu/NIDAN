import './style.css';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';

interface RoadmapNode {
  title: string;
  description: string;
  state: 'completed' | 'current' | 'future';
  icon: string;
}

const steps: RoadmapNode[] = [
  {
    title: 'Learning pathway',
    description: 'A personalized skill pathway is not available yet. NIDAN currently stores a Number Systems diagnostic and school-recorded assignments; prerequisite progression is not connected.',
    state: 'current',
    icon: 'route'
  }
];

const timeline = document.getElementById('roadmap-timeline')!;

steps.forEach((step, index) => {
  const node = document.createElement('div');
  node.className = `timeline-node node-${step.state}`;
  
  // Animation
  node.style.opacity = '0';
  node.style.transform = 'translateX(-20px)';
  node.style.animation = `fadeRight 0.4s ease-out ${index * 0.15}s forwards`;

  node.innerHTML = `
    <div class="timeline-dot ${step.state}"></div>
    <div class="timeline-content">
      <h3>
        <md-icon>${step.icon}</md-icon>
        ${step.title}
      </h3>
      <p>${step.description}</p>
    </div>
  `;
  timeline.appendChild(node);
});

// Add animation keyframe to document head
const style = document.createElement('style');
style.innerHTML = `
  @keyframes fadeRight {
    from { opacity: 0; transform: translateX(-20px); }
    to { opacity: 1; transform: translateX(0); }
  }
`;
document.head.appendChild(style);
