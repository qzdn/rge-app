<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { browser } from "$app/environment";
  import MapBackground from "$lib/components/MapBackground.svelte";
  import PlayerToken from "$lib/components/PlayerToken.svelte";

  interface PlayerToken {
    originalX: number;
    originalY: number;
    size: number;
    color: string;
    name?: string;
  }

  const tokens: PlayerToken[] = [
    {
      size: 64,
      originalX: 1000,
      originalY: 400,
      color: "orange",
      name: "Player 1",
    },
    {
      size: 32,
      originalX: 3000,
      originalY: 1500,
      color: "red",
      name: "Player 2",
    },
  ];

  // Переменные для управления состоянием карты
  let isDragging: boolean = false;
  let translateX: number = 0;
  let translateY: number = 0; // Позиция карты
  let startX: number = 0;
  let startY: number = 0; // Начальные координаты при перетаскивании
  let cursorX: number = 0;
  let cursorY: number = 0; // Координаты курсора
  let scale: number = 1; // Масштаб

  const HEADER_HEIGHT: number = 60;
  const ZOOM_FACTOR: number = 0.25;
  let minScale: number;
  const MAX_SCALE: number = 2;
  const MAP_WIDTH: number = 1024 * 4;
  const MAP_HEIGHT: number = 1152 * 2; // Тайлы

  function getCursorPosition(event: MouseEvent): void {
    cursorX = (event.clientX - translateX) / scale;
    cursorY = (event.clientY - translateY - HEADER_HEIGHT) / scale;
  }

  function calculateScaleAndLimits(): void {
    if (!browser) return;
    const windowWidth: number = window.innerWidth;
    const windowHeight: number = window.innerHeight - HEADER_HEIGHT;

    minScale = Math.max(windowWidth / MAP_WIDTH, windowHeight / MAP_HEIGHT);
    scale = Math.max(scale, minScale);
    limitTranslation();
  }

  function limitTranslation(): void {
    const windowWidth: number = window.innerWidth;
    const windowHeight: number = window.innerHeight - HEADER_HEIGHT;
    const scaledMapWidth: number = MAP_WIDTH * scale;
    const scaledMapHeight: number = MAP_HEIGHT * scale;

    translateX = Math.max(
      Math.min(translateX, 0),
      -(scaledMapWidth - windowWidth)
    );
    translateY = Math.max(
      Math.min(translateY, 0),
      -(scaledMapHeight - windowHeight)
    );
  }

  function handleDrag(event: MouseEvent): void {
    if (isDragging) {
      translateX = event.clientX - startX;
      translateY = event.clientY - startY;
      limitTranslation();
    }
  }

  function startDrag(event: MouseEvent): void {
    isDragging = true;
    startX = event.clientX - translateX;
    startY = event.clientY - translateY;
  }

  function endDrag(): void {
    isDragging = false;
  }

  // Функция для масштабирования карты
  function zoom(event: WheelEvent): void {
    event.preventDefault();
    const previousScale: number = scale;

    // Новый масштаб
    scale = Math.max(
      minScale,
      Math.min(
        scale + (event.deltaY < 0 ? ZOOM_FACTOR : -ZOOM_FACTOR),
        MAX_SCALE
      )
    );

    const mouseX: number = event.clientX;
    const mouseY: number = event.clientY - HEADER_HEIGHT;

    // Пересчитываем позицию карты
    const mapX: number = (mouseX - translateX) / previousScale;
    const mapY: number = (mouseY - translateY) / previousScale;

    translateX = mouseX - mapX * scale;
    translateY = mouseY - mapY * scale;

    limitTranslation();
  }

  let resizeTimeout: ReturnType<typeof setTimeout>;
  onMount(() => {
    if (browser) {
      calculateScaleAndLimits();

      window.addEventListener("resize", () => {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(calculateScaleAndLimits, 100); // Дебаунс 100ms
      });

      window.addEventListener("mousemove", handleDrag);
      window.addEventListener("mouseup", endDrag);
    }
  });

  onDestroy(() => {
    if (browser) {
      window.removeEventListener("resize", calculateScaleAndLimits);
      window.removeEventListener("mousemove", handleDrag);
      window.removeEventListener("mouseup", endDrag);
    }
  });
</script>

<div
  class="container"
  on:mousemove={getCursorPosition}
  on:mousedown={startDrag}
  on:wheel={zoom}
  style="width: 100vw; height: calc(100vh - {HEADER_HEIGHT}px);"
>
  <MapBackground {translateX} {translateY} {scale} />
  <div class="coordinates">
    X: {Math.round(cursorX)} Y: {Math.round(cursorY)}
  </div>

  {#each tokens as { originalX, originalY, size, color, name }}
    <PlayerToken
      x={originalX * scale + translateX - (size * scale) / 2}
      y={originalY * scale + translateY - (size * scale) / 2}
      size={size * scale}
      {originalX}
      {originalY}
      {color}
      {name}
    />
  {/each}
</div>

<style>
  .container {
    overflow: hidden;
    position: relative;
  }

  .coordinates {
    position: fixed;
    top: 70px;
    left: 10px;
    background-color: rgba(40, 44, 52, 0.77);
    color: white;
    padding: 5px;
    border-radius: 5px;
    user-select: none;
    z-index: 1;
  }
</style>
