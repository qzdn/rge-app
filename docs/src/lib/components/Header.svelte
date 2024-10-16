<script lang="ts">
  import { base } from '$app/paths';

  export let title = "RGE Docs";
</script>

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

  a:hover {
    text-decoration: underline;
  }
</style>

<header>
  <h1>{title}</h1>
  <nav>
    <a href="{base}/">Главная</a>
    <a href="{base}/rules">Правила</a>
    <a href="{base}/map">Карта</a>
    <a href="{base}/calc">Калькулятор</a>
  </nav>
</header>
