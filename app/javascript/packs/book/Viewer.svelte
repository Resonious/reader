<script>
  export let content;
  export let page;
  export let pageCount;

  $: lines = content.split('　')
</script>

<style>
#container {
  display: flex;
  align-items: center;

  position: absolute;
  overflow: scroll;
  top: 40px;
  bottom: 20px;
  left: 0;
  right: 0;
}

#pageno {
  position: fixed;
  right: 15px;
  top: 5px;
}

article {
  writing-mode: vertical-rl;
  padding-left: 35px;
  padding-right: 35px;

  line-height: 1.6;
}

.highlight {
  background-color: #fffeae;
}
</style>

<div id='container'>
  <article>
    {#each lines as line}
      <p>{line}</p>
    {/each}
  </article>
</div>
<span id='pageno'>{page}/{pageCount-1}</span>
