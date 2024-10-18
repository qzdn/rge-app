<script lang="ts">
  import { onMount } from "svelte";
  import { browser } from "$app/environment";

  // Переменные для управления параметрами тайлов
  export let translateX: number = 0;
  export let translateY: number = 0;
  export let scale: number = 1;

  const TILE_WIDTH: number = 1024; // Ширина тайла
  const TILE_HEIGHT: number = 1152; // Высота тайла
  const COLUMNS: number = 4; // Количество столбцов
  const ROWS: number = 2; // Количество рядов

  // Массив для хранения всех тайлов и видимых тайлов
  let tiles: Array<{ src: string; x: number; y: number }> = [];
  let visibleTiles: Array<{ src: string; x: number; y: number }> = [];

  // Инициализация тайлов при монтировании компонента
  onMount(() => {
    for (let y = 0; y < ROWS; y++) {
      for (let x = 0; x < COLUMNS; x++) {
        tiles.push({ src: `img/atlas_tiles/atlas_${x}_${y}.webp`, x, y });
      }
    }
    updateVisibleTiles();

    const handleResize = () => {
      requestAnimationFrame(updateVisibleTiles);
    };
    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  });

  // Функция для обновления видимых тайлов в зависимости от позиции и масштаба
  function updateVisibleTiles(): void {
    if (!browser) return;

    const viewportWidth: number = window.innerWidth;
    const viewportHeight: number = window.innerHeight - 60; // Высота хедера

    const startX: number = -translateX / scale;
    const startY: number = -translateY / scale;
    const endX: number = startX + viewportWidth / scale;
    const endY: number = startY + viewportHeight / scale;

    // Фильтруем тайлы на основе их позиций
    visibleTiles = tiles.filter((tile) => {
      const tileLeft: number = tile.x * TILE_WIDTH;
      const tileRight: number = tileLeft + TILE_WIDTH;
      const tileTop: number = tile.y * TILE_HEIGHT;
      const tileBottom: number = tileTop + TILE_HEIGHT;

      return !(
        tileRight < startX ||
        tileLeft > endX ||
        tileBottom < startY ||
        tileTop > endY
      );
    });
  }

  // Реактивный блок для обновления видимых тайлов при изменении пропсов
  $: translateX, translateY, scale, updateVisibleTiles();
</script>

<div
  class="grid"
  style="
    grid-template-rows: repeat({ROWS}, {TILE_HEIGHT}px); 
    grid-template-columns: repeat({COLUMNS}, {TILE_WIDTH}px); 
    transform: translate({Math.round(translateX)}px, {Math.round(translateY)}px) scale({scale});
    width: calc({COLUMNS} * {TILE_WIDTH}px);
    height: calc({ROWS} * {TILE_HEIGHT}px);
  "
>
  {#each visibleTiles as tile}
    <div
      class="tile"
      style="
        background-image: url('{tile.src}');
        width: {TILE_WIDTH + 2}px; /* Костыль для стыков */
        height: {TILE_HEIGHT + 2}px;
        grid-row: {tile.y + 1};  /* Добавление тайлов в ряд */
        grid-column: {tile.x + 1}; /* Добавление тайлов в столбец */
      "
    ></div>
  {/each}
</div>

<style>
  .grid {
    display: grid;
    position: absolute;
    cursor: grab;
    user-select: none;
    transform-origin: top left;
  }

  .grid:active {
    cursor: grabbing;
  }

  .tile {
    background-size: cover;
    background-position: center;
  }
</style>
