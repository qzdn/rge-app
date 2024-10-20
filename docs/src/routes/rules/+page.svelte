<div class="container">
  <!-- Левый блок с разделами -->
  <div class="left">
    <h2>Разделы</h2>
    <ul>
      <li><a href="#section1">Раздел 1</a></li>
      <li><a href="#section2">Раздел 2</a></li>
      <li><a href="#section3">Раздел 3</a></li>
    </ul>
  </div>

  <!-- Центральный блок с текстом -->
  <div class="center">
    <h1>Правила</h1>
    <p>
      Здесь будет описание эвента. Этот текст можно заменить на соответствующий
      контент, связанный с инструкциями, расписанием и другими важными деталями.
    </p>

    <h2 id="section1">Раздел 1</h2>
    <p>Текст для раздела 1...</p>

    <h2 id="section2">Раздел 2</h2>
    <p>Текст для раздела 2...</p>

    <h2 id="section3">Раздел 3</h2>
    <p>Текст для раздела 3...</p>
  </div>

  <!-- Правый блок с навигацией по разделу -->
  <div class="right">
    <h2>Навигация</h2>
    <ul>
      <li><a href="#section1">К разделу 1</a></li>
      <li><a href="#section2">К разделу 2</a></li>
      <li><a href="#section3">К разделу 3</a></li>
    </ul>
  </div>
</div>

<style>
  :root(body) {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  /* Контейнер для всей страницы */
  .container {
    display: flex;
    flex-wrap: nowrap;
    margin: 0;
    height: calc(100vh - 60px);
  }

  /* Левый блок с разделами */
  .left {
    flex: 1;
    padding: 20px;
    background-color: #f4f4f4;
  }

  /* Центральный блок с основным текстом */
  .center {
    flex: 3;
    padding: 20px;
  }

  /* Правый блок с навигацией по разделу */
  .right {
    flex: 1;
    padding: 20px;
    background-color: #f4f4f4;
  }

  /* Стили для списка разделов */
  .left ul,
  .right ul {
    list-style-type: none;
    padding: 0;
  }

  .left ul li,
  .right ul li {
    margin-bottom: 10px;
  }

  .left ul li a,
  .right ul li a {
    text-decoration: none;
    color: #0073e6;
  }

  .left ul li a:hover,
  .right ul li a:hover {
    text-decoration: underline;
  }

  /* Стили для основного контента */
  h1,
  h2 {
    color: #333;
  }

  p {
    line-height: 1.6;
  }

  @media (max-width: 768px) {
    .container {
      flex-direction: column;
      height: auto;
    }

    .left,
    .center,
    .right {
      flex: 1;
      max-width: 100%;
    }
  }
</style>
