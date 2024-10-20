<script lang="ts">
  import { onDestroy } from "svelte";
  import { browser } from "$app/environment";
  import ItemsBackground from "$lib/components/ItemsBackground.svelte";

  let dataArray: string[] = [];
  let currentIndex: number = 0;
  let selectedItem: string = "...";
  let isFading: boolean = false;
  let iterations: number = 0;
  let interval: number;

  const UPDATE_TIME: number = 300;
  const MAX_ITERATIONS: number = 118;

  let rollAudio: HTMLAudioElement;
  let rollMusic: string = "";
  const rollStopSound = "snd/eto_4e_takoe.mp3";
  let volume: number = 0.5;

  function randomizeRollMusic(): void {
    // Generate a random number between 1 and 9
    const randomNumber = Math.floor(Math.random() * 9) + 1;
    // Construct the file name
    rollMusic = `snd/roll_music_${randomNumber}.mp3`;
  }

  async function loadFile(file: string): Promise<void> {
    const response = await fetch(file);
    if (response.ok) {
      dataArray = (await response.text())
        .split("\n")
        .filter(item => item.trim());
      resetState();
    }
  }

  function resetState() {
    currentIndex = 0;
    selectedItem = shuffleItems(dataArray)[currentIndex];
    iterations = 0;
    randomizeRollMusic();
    prepareAudio(rollMusic);
  }

  function shuffleItems(array: string[]): string[] {
    return array.sort(() => Math.random() - 0.5);
  }

  function prepareAudio(src: string): void {
    rollAudio.src = src;
    rollAudio.load();
  }

  function updateItem(): void {
    if (isFading || iterations >= MAX_ITERATIONS) return;

    isFading = true;
    setTimeout(() => {
      currentIndex = (currentIndex + 1) % dataArray.length;
      selectedItem = dataArray[currentIndex];
      isFading = false;
      rollAudio.play();
      iterations++;

      if (iterations >= MAX_ITERATIONS) {
        prepareAudio(rollStopSound);
        rollAudio.play();
        clearInterval(interval);
      }
    }, 150);
  }

  function randomizeItem(): void {
    if (browser && dataArray.length > 0) {
      clearInterval(interval);
      resetState();
      interval = setInterval(updateItem, UPDATE_TIME);
    }
  }

  $: if (browser && rollAudio) rollAudio.volume = volume;

  onDestroy(() => {
    clearInterval(interval);
    clearTimeout(interval);
    if (browser && rollAudio) rollAudio.remove();
  });
</script>

<div class="item-container">
  <ItemsBackground />
  <div class="item-row">
    <div class="item-bg">
      <p class={`item ${isFading ? "fade-out" : "fade-in"} ${iterations >= MAX_ITERATIONS ? "highlighted" : ""}`}>
        {selectedItem}
      </p>
    </div>
    <button class="roll-button" on:click={randomizeItem}>
      <img src="https://cdn.7tv.app/emote/603cbfe173d7a5001441f9e7/2x.webp" alt="BlessRNG" />
    </button>
  </div>
  <div class="bottom-elements">
    <a role="button" on:click={() => loadFile("data/games.txt")}>игры</a> |
    <a role="button" on:click={() => loadFile("data/items.txt")}>предметы</a> |
    <a role="button">чё-то ещё xd</a>
    <input type="range" min="0" max="1" step="0.1" bind:value={volume} style="margin-left: 5rem;"/>
  </div>

    <audio bind:this={rollAudio} src={rollMusic} {volume} preload="auto"></audio>
</div>

<style>
  a {
    cursor: pointer;
  }

  .item-container {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    height: calc(100vh - 60px);
  }

  .item-row {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .roll-button {
    width: 5vw;
    height: 8rem;
    background-color: rgba(30, 40, 50, 0.66);
    border-radius: 1rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
    z-index: 1;
  }

  .item-bg {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 75vw;
    height: 8rem;
    background-color: rgba(30, 40, 50, 0.66);
    border-radius: 1rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
    z-index: 1;
  }

  .item {
    font-size: 2.15rem;
    line-height: 3rem;
    color: white;
    opacity: 1;
    transition: opacity 150ms ease;
    filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, 1));
  }

  .highlighted {
    color: yellowgreen;
    font-weight: bold;
  }

  .bottom-elements {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 1.5rem;
    font-size: 1.25rem;
    margin-top: 1rem;
    z-index: 1;
  }

  button > img {
    width: 100%;
  }

  .fade-out {
    opacity: 0;
  }

  .fade-in {
    opacity: 1;
  }
</style>
