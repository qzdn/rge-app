<script lang="ts">
  import { onDestroy } from "svelte";

  const LINES_COUNT = 42;
  const IMAGES_COUNT = 116;

  let imagePaths: string[] = [];
  let opacity: number = 1;

  // Pre-generate all image paths
  const imagePool = Array.from(
    { length: IMAGES_COUNT },
    (_, i) => `/img/items/${i + 1}.webp`
  );

  function getRandomImagePaths(count: number): string[] {
    return Array.from({ length: count }, () => {
      const randomIndex = Math.floor(Math.random() * imagePool.length);
      return imagePool[randomIndex];
    });
  }

  function initializeImagePaths() {
    imagePaths = getRandomImagePaths(LINES_COUNT);
  }

  function handleScrollEnd() {
    imagePaths = [...imagePaths.slice(1), getRandomImagePaths(1)[0]];
  }

  initializeImagePaths();

  let intervalId = setInterval(() => {
    handleScrollEnd();
  }, 1000 * 90);

  onDestroy(() => clearInterval(intervalId));
</script>

<div class="gradient">
  <div class="scrolling-bg">
    <div class="scrolling-row">
      {#each imagePaths as path, i}
        <div class="image-item-container" style="opacity: {opacity}">
          <img class="image-item" src={path} alt="Image {i + 1}" />
        </div>
      {/each}
    </div>
  </div>
</div>

<style>
  .scrolling-bg {
    display: flex;
    overflow: hidden;
    width: 100vw;
    height: calc(100vh - 60px);
    position: absolute;
    top: 0;
    left: 0;
    background-color: rgb(25, 25, 50);
    z-index: -1;
    perspective: 800px; /* Добавляем перспективу */
  }

  .scrolling-row {
    display: flex;
    flex-wrap: wrap;
    width: 100%;
    height: 100%;
    margin-left: 3rem;
    scale: 1.2;
    animation: animatedBackground 90s linear infinite;
  }

  .image-item-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 4rem;
  }

  .image-item {
    max-width: 7rem;
    max-height: 7rem;
    object-fit: cover;
    filter: drop-shadow(5px 5px 5px rgba(0, 0, 0, 0.75));
    -webkit-filter: drop-shadow(5px 5px 5px rgba(0, 0, 0, 0.75));
  }

  .gradient {
    position: absolute;
    background: linear-gradient(
      to bottom,
      rgba(49, 52, 61, 0) 0%,
      rgba(20, 30, 48, 0.9) 50%,
      #141e30 100%
    );
    height: 100%;
    width: 100%;
    top: 0;
  }

  @keyframes animatedBackground {
    0% {
      opacity: 0;
      transform: scale(1.25) rotateX(20deg) translateX(-10px) translateY(0);
    }
    5% {
      opacity: 0.5;
    }
    97% {
      opacity: 0.5;
    }
    100% {
      opacity: 0;
      transform: scale(1.25) rotateX(25deg) translateX(0) translateY(-85%);
    }
  }
</style>
