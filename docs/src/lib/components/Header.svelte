<script lang="ts">
  import { base } from "$app/paths";
  import github from "$lib/images/github.svg";

  let isMenuOpen: boolean = false;
</script>

<header>
  <h1>RGE Docs</h1>
  <button class="hamburger" on:click={() => (isMenuOpen = !isMenuOpen)}>
    &#9776; <!-- Иконка -->
  </button>
  <nav class={isMenuOpen ? "open" : ""}>
    <a href="{base}/" on:click={() => (isMenuOpen = false)}>Главная</a>
    <a href="{base}/rules" on:click={() => (isMenuOpen = false)}>Правила</a>
    <a href="{base}/map" on:click={() => (isMenuOpen = false)}>Карта</a>
    <a href="{base}/calc" on:click={() => (isMenuOpen = false)}>Калькулятор</a>
    <span class="divider">|</span>
    <a href="https://github.com/qzdn/rge-app" on:click={() => (isMenuOpen = false)}>
      <svg width="24" height="24" xmlns="http://www.w3.org/2000/svg">
        <image href={github} width="24" height="24" />
      </svg>
    </a>
  </nav>
</header>

<style>
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    background-color: #282c34;
    color: white;
  }

  h1 {
    margin: 0;
    font-size: 1.5rem;
  }

  nav {
    display: flex;
    gap: 1rem;
  }

  nav.open {
    display: flex;
  }

  nav > a {
    text-align: center;
  }

  .divider {
    display: none;
  }

  .hamburger {
    display: none;
    font-size: 24px;
    background: none;
    border: none;
    color: white;
    cursor: pointer;
  }

  @media (max-width: 768px) {
    nav {
      display: none;
      flex-direction: column;
      position: absolute;
      background-color: #282c34;
      top: 50px;
      left: 0;
      width: 100%;
      z-index: 10;
    }

    nav.open {
      display: flex;
    }

    .hamburger {
      display: block;
    }
  }

  @media (min-width: 769px) {
    .divider {
      display: inline;
      margin: 0 0.25rem; 
    }
  }
</style>
