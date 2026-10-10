import './style.css';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/tabs/tabs.js';
import '@material/web/tabs/primary-tab.js';

const grid = document.getElementById('library-grid')!;
const searchInput = document.getElementById('search-input') as HTMLInputElement;
const status = document.createElement('p');
status.style.cssText = 'grid-column: 1 / -1; color: var(--text-secondary); padding: 2rem 0;';
status.textContent = 'No school-approved resources are installed on this device yet.';
grid.replaceChildren(status);
searchInput.disabled = true;
