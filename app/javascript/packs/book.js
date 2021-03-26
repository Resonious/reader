import Viewer from './book/Viewer.svelte'

document.addEventListener('DOMContentLoaded', () => {
  const target = document.getElementById('viewer')
  new Viewer({ target, props: window.book })
})
