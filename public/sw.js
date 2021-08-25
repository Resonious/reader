const cacheName = 'ja-reader-1'

self.addEventListener('install', () => {
  console.log('[Service Worker] install!')
})

// Simple cache of everything...
self.addEventListener('fetch', (e) => {
  e.respondWith((async () => {
    console.log(e.request);
    const r = await caches.match(e.request);
    console.log(`[Service Worker] Handling ${e.request.url}`);
    if (r) return r;
    const response = await fetch(e.request);
    const cache = await caches.open(cacheName);
    console.log(`[Service Worker] Caching new resource: ${e.request.url}`);
    cache.put(e.request, response.clone());
    return response;
  })());
});
