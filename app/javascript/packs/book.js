import Lookup from 'book/Lookup.svelte'
const debounce = require('lodash/debounce')

document.addEventListener('DOMContentLoaded', () => {
  const target = document.getElementById('lookup')
  window.lookup = new Lookup({ target, props: window.book })

  window.lookupRequest = debounce(
    (x, callback) => fetch(`/lookup/${x}`)
    .then(r => r.status === 404 ? { meta: { status: 404 }, data: [] } : r.json())
    .then(callback),
    300
  )
})
