<script>
  export let query = null
  export let results = { meta: {}, data: [] }
  export let page = 0;
  export let pageCount = 0;

  const commonParticles = ['が', 'は', 'を']

  $: result = results.data.length > 1 && commonParticles.includes(results.data[0].slug)
              ? results.data[1] : results.data[0]

  $: slug = result && result.slug

  $: kanji = result && result.japanese[0].word
  $: furigana = result && result.japanese[0].reading
  $: jlpt = result && result.jlpt[0]

  $: senses = (result && result.senses) || []

  function close() {
    results.data = []
  }

  function gotoPage() {
    const components = location.pathname.split('/')
    components[components.length - 1] = page
    location.href = components.join('/')
  }

  let fetchText = 'Fetch'
  async function fetchForCache() {
    const components = location.pathname.split('/')
    const currentPage = Number(components[components.length - 1])

    for (let i = currentPage + 1; i <= page; ++i) {
      fetchText = String(i)
      components[components.length - 1] = i
      await fetch(components.join('/'))
    }
    fetchText = 'Done';
  }
</script>

<style>
  .main {
    display: flex;
    flex-direction: row;
    box-sizing: border-box;

    height: 100%;
    padding: 5px;

    overflow-y: scroll;
  }

  .def {
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    margin-right: 5px;
  }

  a {
    font-size: 140%;
  }

  .senses {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    margin-left: 5px;
  }

  ul {
    background-color: var(--color-bump2);
    padding: 5px;
    margin: 5px;
  }

  li {
    list-style: none;
  }

  input {
    margin: 5px;
    width: 5em;
  }

  button {
    background-color: var(--color-bump2);
    box-shadow: 0px 1px 2px black;
    margin: 5px;
    min-width: 40px;
  }
</style>

<div class='main'>
  {#if slug}
    <div class='def'>
      <a href='https://jisho.org/search/{query}' target=_blank>
        {#if kanji}
          <ruby>{kanji}<rt>{furigana}</rt></ruby>
        {:else}
          {slug}
        {/if}
      </a>
      {#if jlpt}
        <small>{jlpt}</small>
      {/if}
    </div>
  {/if}

  <div class='senses'>
    {#each senses as sense}
      <ul>
        {#each sense.english_definitions as definition}
          <li>{definition}</li>
        {/each}
      </ul>
    {/each}
    {#if senses.length > 0}
      <button on:click={close}>&times;</button>
    {:else}
      <form on:submit|preventDefault={gotoPage}>
        <input type=number min=0 max={pageCount-1} bind:value={page} />
        <button type=submit>Go</button>
      </form>
      <button on:click={fetchForCache}>{fetchText}</button>
    {/if}
  </div>
</div>
