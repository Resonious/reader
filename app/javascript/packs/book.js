import Lookup from 'book/Lookup.svelte'
const throttle = require('lodash/throttle')

let lookup

document.addEventListener('DOMContentLoaded', () => {
  const target = document.getElementById('lookup')
  lookup = new Lookup({ target, props: window.book })

  // Wow the concept of "page" is just messed up
  localStorage.setItem(`${window.book.slug}-paragraph`, window.book.page)
})


// --- navigation --- //

const hashchange = (arg) => {
  if (arg === 'first' && (!location.hash || location.hash.length <= 1)) {
    const stored = localStorage.getItem(`${window.book.slug}-page`)
    if (stored && stored.length > 0)
      location.hash = stored
    else {
      const first = document.querySelector('article p:first-child')
      location.hash = `#${first.id}`
    }
    return
  }

  const n = location.hash.substr(1)

  if (arg === 'first') {
    if (n === 'first') {
      const selected = document.querySelector('article p:first-child')
      location.hash = `#${selected.id}`
      return
    }
    else if (n === 'last') {
      const selected = document.querySelector('article p:last-child')
      location.hash = `#${selected.id}`
      return
    }
  }

  const selected = document.querySelector(`#${n}`)

  for (const el of document.querySelectorAll('.highlight'))
    el.classList.remove('highlight')

  if (selected) {
    selected.classList.add('highlight')
    localStorage.setItem(`${window.book.slug}-page`, n)
  }
  else
    localStorage.setItem(`${window.book.slug}-page`, null)
}

document.addEventListener('DOMContentLoaded', () => {
  for (const el of document.querySelectorAll('article p')) {
    el.onclick = () => {
      const range = window.getSelection().getRangeAt(0)

      if (range.startOffset === range.endOffset)
        document.location.hash = `#${el.id}`
    }
  }
  for (const el of document.getElementsByClassName('nav-btn')) {
    el.addEventListener('click', () => {
      const anchor = el.href.split('#')[1]
      localStorage.setItem(`${window.book.slug}-page`, anchor)
    })
  }
  hashchange('first')
})

window.addEventListener('hashchange', hashchange)


// --- Lookup-on-select --- //

const lookupRequest = throttle(
  (x, callback) => fetch(`/lookup/${x}`)
  .then(r => r.status === 404 ? { meta: { status: 404 }, data: [] } : r.json())
  .then(callback),
  150
)

document.addEventListener('selectionchange', async() => {
  const text = document.getSelection().toString()
  if (!text) return
  if (text.length > 10) return
  if (text.length <= 0) return

  lookupRequest(text, results => lookup.$set({results, query: text, index: 0}))
})


// --- Font zoom --- //

document.addEventListener('DOMContentLoaded', () => {
  const zoomInput = document.getElementById('font-zoom')
  const content = document.getElementById('container').getElementsByTagName('article')[0]
  const defaultSize = 20

  const updateFontSize = () => {
    content.style.fontSize = `${zoomInput.value}px`

    if (zoomInput.value == defaultSize)
      localStorage.removeItem('fontsize')
    else
      localStorage.setItem('fontsize', zoomInput.value)
  }

  const fromStorage = localStorage.getItem('fontsize')
  if (fromStorage) zoomInput.value = fromStorage
  else zoomInput.value = defaultSize
  zoomInput.addEventListener('input', updateFontSize)
  updateFontSize()

  const resetButton = document.getElementById('reset-zoom')
  resetButton.addEventListener('click', () => {
    zoomInput.value = 20
    updateFontSize()
  })
})
