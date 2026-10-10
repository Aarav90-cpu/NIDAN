import { defineConfig } from 'vite';
import { resolve } from 'node:path';

const frontendDirectory = import.meta.dirname;

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(frontendDirectory, 'index.html'),
        diagnostic: resolve(frontendDirectory, 'diagnostic.html'),
        learning: resolve(frontendDirectory, 'learning.html'),
        assignments: resolve(frontendDirectory, 'assignments.html'),
        progress: resolve(frontendDirectory, 'progress.html'),
        roadmap: resolve(frontendDirectory, 'roadmap.html'),
        library: resolve(frontendDirectory, 'library.html'),
        settings: resolve(frontendDirectory, 'settings.html'),
        onboarding: resolve(frontendDirectory, 'onboarding.html'),
        teacher: resolve(frontendDirectory, 'teacher.html'),
        leadership: resolve(frontendDirectory, 'leadership.html')
      }
    }
  }
});
