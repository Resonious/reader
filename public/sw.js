const cacheName = 'ja-reader-2'

self.addEventListener('install', () => {
  console.log('[Service Worker] install!')
})

// We do a real fetch everytime, returning a cache in case of network errors.
self.addEventListener('fetch', (event) => {
  event.respondWith((async () => {
    console.log(event.request);

    try {
      // Fetch it for real
      const realResponse = await fetch(event.request);
      if (!realResponse.ok) return realResponse;

      // Stick it in the cache if it was OK
      if (realResponse.ok) {
        const cache = await caches.open(cacheName);
        console.log(`[Service Worker] Caching new resource: ${event.request.url}`);
        cache.put(event.request, realResponse.clone());
      }

      // Return it
      return realResponse;
    }
    catch (error) {
      // Return cached response if real one failed
      const cachedResponse = await caches.match(event.request);
      console.log(`[Service Worker] Returning cached ${event.request.url}`);
      if (cachedResponse) return cachedResponse;
      else throw error;
    }
  })());
});
