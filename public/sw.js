const cacheName = 'ja-reader-2'

self.addEventListener('install', () => {
  console.log('[Service Worker] install!')
})

function returnCacheImmediately(url) {
  return url.endsWith('.js') ||
    url.endsWith('.css') ||
    url.includes('/lookup/');
}

function dontSaveToCache(url) {
  return url.endsWith('/whoareyou');
}

// We do a real fetch everytime, returning a cache in case of network errors.
self.addEventListener('fetch', (event) => {
  event.respondWith((async () => {
    // Only muck around with cache for GET requests
    if (event.request.method !== 'GET')
      return fetch(event.request);

    console.log(event.request);
    const url = event.request.url;

    try {
      // Try cache first, only if it is an asset or dict lookup
      if (returnCacheImmediately(url)) {
        const cachedResponse = await caches.match(event.request);
        if (cachedResponse) return cachedResponse;
      }

      // Fetch it for real
      const realResponse = await fetch(event.request);
      if (!realResponse.ok) return realResponse;

      // Stick it in the cache if it was OK
      if (!dontSaveToCache(url) && realResponse.ok) {
        const cache = await caches.open(cacheName);
        console.log(`[Service Worker] Caching new resource: ${url}`);
        cache.put(event.request, realResponse.clone());
      }

      // Return it
      return realResponse;
    }
    catch (error) {
      // Return cached response if real one failed
      const cachedResponse = await caches.match(event.request);
      console.log(`[Service Worker] Returning cached ${url}`);
      if (cachedResponse) return cachedResponse;
      else throw error;
    }
  })());
});
