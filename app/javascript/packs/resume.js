function jumpToBook() {
  if (!location.hash || location.hash.length <= 1) {
    location.replace('/')
    return
  }

  const book = location.hash.substr(1)
  const para = localStorage.getItem(`${book}-paragraph`)

  if (para && para.length > 0) {
    location.replace(`/book/${book}/${para}`)
    return
  }

  location.replace(`/book/${book}/0`)
}

jumpToBook()
