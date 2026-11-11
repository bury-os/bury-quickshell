/**
 * Lighten an RGB color
 */
function lighten(color, amount = 0.15) {
  color = color.toString() // Force color as string

  const r = parseInt(color.slice(1, 3), 16);
  const g = parseInt(color.slice(3, 5), 16);
  const b = parseInt(color.slice(5, 7), 16);

  return '#' + [r, g, b]
    .map(c => Math.round(c + (255 - c) * amount)
      .toString(16)
      .padStart(2, "0"))
    .join('')
}

/**
 * Darken an RGB color
 */
function darken(color, amount = 0.15) {
  color = color.toString(); // Force color as string

  const r = parseInt(color.slice(1, 3), 16);
  const g = parseInt(color.slice(3, 5), 16);
  const b = parseInt(color.slice(5, 7), 16);

  return '#' + [r, g, b]
    .map(c => Math.round(c * (1 - amount))
      .toString(16)
      .padStart(2, "0"))
    .join('')
}

/**
 * Invert an RGB color.
 */
function invert(color) {
  color = color.toString(); // Force color as string

  const r = parseInt(color.slice(1, 3), 16);
  const g = parseInt(color.slice(3, 5), 16);
  const b = parseInt(color.slice(5, 7), 16);

  return '#' + [r, g, b]
    .map(c => (255 - c)
      .toString(16)
      .padStart(2, "0"))
    .join('');
}

/**
 * Highlight an RGB color, themeing aware.
 */
function highlight(color, isDarkMode = false, amount = 0.15) {
  return isDarkMode
    ? lighten(color, amount)
    : darken(color, amount)
}

/**
 * Mute an RGB color, themeing aware.
 */
function mute(color, isDarkMode  = false, amount = 0.15) {
  return isDarkMode
    ? darken(color, amount)
    : lighten(color, amount)
}