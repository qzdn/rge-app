<script lang="ts">
  import PointsCalculator from "$lib/components/PointsCalculator.svelte";
  import KaTeXRenderer from "$lib/components/KaTeXRenderer.svelte";
</script>

<div class="container">
  <h1>Калькулятор</h1>
  <PointsCalculator />

  <details>
    <summary>Пояснения</summary>

    <h2>Расчёт количества очков за прохождение игры</h2>
    <h3>Основная формула:</h3>
    <KaTeXRenderer
      formula={`Points = \\left( WalkthroughTimeMultiplier \\times DifficultyMultiplier \\times GameFAQsDifficultyMultiplier \\times MetascoreMultiplier \\right) \\times 10`}
      displayMode="display"
    />
    Итоговый результат округляется до целого числа:
    <KaTeXRenderer
      formula={`\\left\\lfloor 68.5562 \\right\\rceil = 69 \\\\ \\left\\lfloor 68.317 \\right\\rceil = 68`}
      displayMode="display"
    />

    <h3>1. Множитель времени прохождения:</h3>
    Время прохождения игры (<KaTeXRenderer
      formula={`WalkthroughTime`}
      displayMode="inline"
    />) берётся с
    <a href="https://howlongtobeat.com/" target="_blank">HowLongToBeat.com</a>:
    <KaTeXRenderer
      formula={`WalkthroughTime = Hours + \\frac{Mins}{60}`}
      displayMode="display"
    />
    <KaTeXRenderer
      formula={`WalkthroughTimeMultiplier = 1 + WalkthroughTime`}
      displayMode="display"
    />

    <h3>2. Множитель сложности:</h3>
    Условия для множителя сложности:
    <KaTeXRenderer
      formula={`DifficultyMultiplier =
      \\begin{cases}
      1, & \\text{если открыта только одна сложность или возможность выбора отсутствует} \\\\
      1, & \\text{если 2 уровня сложности Easy/Normal или Normal/Hard, выбран Normal} \\\\
      0.7, & \\text{если 2 уровня сложности (Easy/Normal), выбран Easy} \\\\
      1.4, & \\text{если 2 уровня сложности (Normal/Hard), выбран Hard} \\\\
      0.7 + \\left( \\frac{SelectedDifficulty - 1}{DifficultiesCount - 1} \\right) \\times (1.4 - 0.7), & \\text{если уровней сложности > 2}
      \\end{cases}`}
      displayMode="display"
    />
    Если в игре множественный выбор сложности (например, как в
    <a href="https://youtu.be/VUnvAuauSW4?t=3" target="_blank">Silent Hill 2</a>
    - Action Level и Riddle Level), то множитель высчитывается как среднее арифметическое
    значение:
    <KaTeXRenderer
      formula={`\\overline{DifficultyMultiplier} = 
      \\frac{1}{n}\\sum_{i=1}^{n}{DifficultyMultiplier}_i = 
      \\frac{1}{n}DifficultyMultiplier_{1} + DifficultyMultiplier_{2} + \\dots + DifficultyMultiplier_{n}`}
      displayMode="display"
    />

    <h3>3. Множитель сложности с GameFAQs:</h3>
    Показатель сложности (<KaTeXRenderer
      formula={`GameFAQsDifficulty`}
      displayMode="inline"
    />) и количество проголосовавших (<KaTeXRenderer
      formula={`GameFAQsVotesCount`}
      displayMode="inline"
    />) берутся с
    <a href="https://gamefaqs.gamespot.com/" target="_blank">GameFAQs</a>. На
    основе количества проголосовавших рассчитывается небольшая прибавка:
    <KaTeXRenderer
      formula={`VoteBonus = \\begin{cases}
      0.2, & \\text{если 0 < GameFAQsVotesCount ≤ 5} \\\\
      0.175, & \\text{если 5 < GameFAQsVotesCount ≤ 50} \\\\
      0.15, & \\text{если 50 < GameFAQsVotesCount ≤ 250} \\\\
      0.1, & \\text{если 250 < GameFAQsVotesCount ≤ 1000} \\\\
      0.075, & \\text{если GameFAQsVotesCount > 1000}
      \\end{cases}`}
      displayMode="display"
    />
    Формула расчёта множителя:
    <KaTeXRenderer
      formula={`GameFAQsDifficultyMultiplier = 1 + \\left(-0.2 + \\frac{GameFAQsDifficulty - 1}{4} \\times \\left(-0.2 + 0.75\\right)\\right) + voteBonus`}
      displayMode="display"
    />

    <h3>4. Множитель рейтинга:</h3>
    Множитель рейтинга рассчитывается на основе среднего балла критиков и юзеров
    с <a href="https://metacritic.com/games" target="_blank">Metacritic</a>:
    <KaTeXRenderer
      formula={`MetascoreMultiplier = 1 + \\frac{85 - \\left( \\frac{CriticsScore + UsersScore}{2} \\right)}{150}`}
      displayMode="display"
    />
  </details>
</div>

<style>
  .container {
    margin: 1rem;
  }

  details {
    background-color: gainsboro;
    border-radius: 5px;
    padding: 1rem;
  }

  details:hover {
    cursor: pointer;
    background-color: lightgray;
  }
</style>
