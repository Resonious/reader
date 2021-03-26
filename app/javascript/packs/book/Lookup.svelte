<script>
  export let query = null
  export let results = { meta: {}, data: [] }

  $: result = results.data[0]

  $: slug = result && result.slug

  $: kanji = result && result.japanese[0].word
  $: furigana = result && result.japanese[0].reading

  $: senses = (result && result.senses) || []
</script>

<style>
  .main {
    display: flex;
    flex-direction: row;

    height: 100%;

    overflow-y: scroll;
  }

  a {
    font-size: 140%;
  }

  .senses {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
  }
</style>

<div class='main'>
  {#if slug}
    <a href='https://jisho.org/search/{query}' target=_blank>
      {#if kanji}
        <ruby>{kanji}<rt>{furigana}</rt></ruby>
      {:else}
        {slug}
      {/if}
    </a>
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
