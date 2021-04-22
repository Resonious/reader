<script>
  export let query = null
  export let results = { meta: {}, data: [] }

  const commonParticles = ['が', 'は', 'を']

  $: result = results.data.length > 1 && commonParticles.includes(results.data[0].slug)
              ? results.data[1] : results.data[0]

  $: slug = result && result.slug

  $: kanji = result && result.japanese[0].word
  $: furigana = result && result.japanese[0].reading
  $: jlpt = result && result.jlpt[0]

  $: senses = (result && result.senses) || []
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
  </div>
</div>
