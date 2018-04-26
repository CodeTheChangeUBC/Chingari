export function copy_to_clipboard(string) {
  const hidden_element = document.createElement('textarea')
  hidden_element.value = string
  hidden_element.setAttribute('readonly', '')
  hidden_element.style.position = 'absolute'
  hidden_element.style.left = '-9999px'
  document.body.appendChild(hidden_element)
  hidden_element.select()
  document.execCommand('copy')
  document.body.removeChild(hidden_element)
}

export function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export function capitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}