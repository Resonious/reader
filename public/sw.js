const cacheName = 'ja-reader-1'

self.addEventListener('install', () => {
  console.log('[Service Worker] install!')
})

// Simple cache of everything...
self.addEventListener('fetch', (e) => {
  e.respondWith((async () => {
    console.log(e.request);

    // Return cached response if present
    const cachedResponse = await caches.match(e.request);
    console.log(`[Service Worker] Handling ${e.request.url}`);
    if (cachedResponse) return cachedResponse;

    // Fetch it for real
    const realResponse = await fetch(e.request);
    if (!realResponse.ok) return realResponse;

    // Stick it in the cache if it was OK
    const cache = await caches.open(cacheName);
    console.log(`[Service Worker] Caching new resource: ${e.request.url}`);
    cache.put(e.request, realResponse.clone());
    return realResponse;
  })());
});
