import './style.css';
import '@material/web/icon/icon.js';
import '@material/web/iconbutton/icon-button.js';
import '@material/web/list/list.js';
import '@material/web/list/list-item.js';
import '@material/web/divider/divider.js';
import '@material/web/button/outlined-button.js';

const accountName = document.getElementById('account-name')!;
const accountRole = document.getElementById('account-role')!;
const logoutButton = document.getElementById('logout-btn')! as any;

async function loadAccount() {
	try {
		const response = await fetch('/api/me');
		if (response.status === 401 || response.status === 404) {
			window.location.href = '/onboarding.html';
			return;
		}
		if (!response.ok) throw new Error('Could not load the signed-in profile.');

		const user = await response.json();
		accountName.textContent = user.name;
		const roleLabels: Record<string, string> = {
			student: 'Student account',
			teacher: 'Teacher account',
			vicePrincipal: 'Vice-principal account',
			principal: 'Principal account'
		};
		accountRole.textContent = roleLabels[user.role] || 'School account';
	} catch {
		accountRole.textContent = 'Account unavailable while offline.';
	}
}

logoutButton.addEventListener('click', async () => {
	logoutButton.disabled = true;
	try {
		const response = await fetch('/api/logout', { method: 'POST' });
		if (!response.ok) throw new Error('Could not end this session.');
		window.location.href = '/onboarding.html';
	} catch {
		logoutButton.disabled = false;
		alert('Sign out failed. Reconnect to the local NIDAN service and try again.');
	}
});

void loadAccount();
