<script lang="ts">
  import katex from 'katex';
  import 'katex/dist/katex.min.css';

  export let formula: string = '';
  export let displayMode: 'inline' | 'display' = 'display';

  let renderedFormula: string = '';

  $: if (formula) {
      const options = { displayMode: displayMode === 'display' };
      renderedFormula = katex.renderToString(formula, options);
  }
</script>

{#if displayMode === 'display'}
    <div class="katex-container" bind:innerHTML={renderedFormula} contenteditable="true"></div>
{:else}
    <span class="katex-container" bind:innerHTML={renderedFormula} contenteditable="true"></span>
{/if}

<style>
  .katex-container {
    text-align: center;
    margin-bottom: 1rem;
    font-size: 1.1rem;
  } 
</style>
