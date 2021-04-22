// Light and dark mode
document.addEventListener('DOMContentLoaded', function() {
  const container = document.body;

  const setThemeToLight = function(match) {
    if (!match.matches) return;
    container.classList.remove('dark');
    container.classList.add('light');
  }

  const setThemeToDark = function(match) {
    if (!match.matches) return;
    container.classList.remove('light');
    container.classList.add('dark');
  }

  // Watch preference and update class
  const prefersLight = window.matchMedia('(prefers-color-scheme: light)');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

  prefersLight.addListener(setThemeToLight);
  prefersDark.addListener(setThemeToDark);

  // Default value
  container.classList.add('light');

  // Set initial values
  setThemeToLight(prefersLight);
  setThemeToDark(prefersDark);
});
