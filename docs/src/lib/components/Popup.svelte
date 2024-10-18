<script lang="ts">
  export let x: number;
  export let y: number;
  export let name: string;
  export let originalX: number;
  export let originalY: number;
  export let show: boolean = false;
</script>

{#if show}
  <div class="popup" style="top: {y}px; left: {x}px;">
    <p><strong>{name}</strong></p>
    <p>Position: {originalX}, {originalY}</p>
  </div>
{/if}

<style>
  .popup {
    position: fixed;
    background-color: #333;
    color: white;
    padding: 5px;
    border-radius: 5px;
    font-size: 12px;
    white-space: nowrap;
    pointer-events: none;
  }
</style>
