<script lang="ts">
  export let x: number;
  export let y: number;
  export let size: number = 32;
  export let color: string = "white";
  export let name: string = "Player";
  export let originalX: number;
  export let originalY: number;

  let showPopup: boolean = false;
  let popupX: number = 0;
  let popupY: number = 0;

  function handleMouseOver(): void {
    showPopup = true;
  }

  function handleMouseOut(): void {
    showPopup = false;
  }

  function handleMouseMove(event: MouseEvent): void {
    requestAnimationFrame(() => {
      popupX = event.clientX + 10;
      popupY = event.clientY + 10;
    });
  }
</script>

<div
  class="player-token"
  style="--x: {x}px; --y: {y}px; --size: {size}px; --color: {color};"
  on:mouseover={handleMouseOver}
  on:mouseout={handleMouseOut}
  on:mousemove={handleMouseMove}
></div>

{#if showPopup}
  <div class="popup" style="top: {popupY}px; left: {popupX}px;">
    <p><strong>{name}</strong></p>
    <p>Position: {originalX}, {originalY}</p>
  </div>
{/if}

<style>
  .player-token {
    position: absolute;
    pointer-events: auto;
    border-radius: 50%;
    border: 3px solid white;
    transform: translate(var(--x), var(--y));
    width: var(--size);
    height: var(--size);
    background-color: var(--color);
    transform-origin: center;
  }

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
