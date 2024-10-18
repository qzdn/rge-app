<script lang="ts">
  import DifficultySelector from "$lib/components/DifficultySelector.svelte";
  import KaTeXRenderer from "$lib/components/KaTeXRenderer.svelte";

  let walkthroughHours: number = 1;
  let walkthroughMins: number = 0;
  let isDifficultiesCountMoreThanOne: boolean = false;
  let difficultiesCount: number = 0;
  let difficulties: any[] = [];
  let gamefaqsDifficulty: number = 3.5;
  let gamefaqsVotesCount: number = 1;
  let criticsScore: number = 85;
  let usersScore: number = 85;

  let walkthroughTimeMultiplier: number = 1;
  let difficultyMultiplier: number = 1;
  let gamefaqsDifficultyMultiplier: number = 1;
  let metascoreMultiplier: number = 1;
  let points: number = 0;

  function handleDifficultiesChange() {
    // Пересоздаём массив, чтобы обновления были реактивны
    let updatedDifficulties = [...difficulties];

    if (updatedDifficulties.length < difficultiesCount) {
      // Добавляем новые блоки
      while (updatedDifficulties.length < difficultiesCount) {
        updatedDifficulties.push({
          selectedDifficulty: 2,
          difficultiesCount: 3,
          selectedDifficultiesOption: "NormalHard",
        });
      }
    } else if (updatedDifficulties.length > difficultiesCount) {
      // Убираем лишние блоки
      updatedDifficulties.splice(difficultiesCount);
    }

    difficulties = updatedDifficulties;
    calculatePoints();
  }

  function onDifficultyChange(
    index: number,
    selectedDifficulty: number,
    difficultiesCount: number,
    selectedDifficultiesOption: string
  ) {
    difficulties = difficulties.map((difficulty, i) => {
      if (i === index) {
        return {
          selectedDifficulty,
          difficultiesCount,
          selectedDifficultiesOption,
        };
      }
      return difficulty;
    });
    calculatePoints();
  }

  function calculatePoints(): void {
    // WalkthroughTimeMultiplier
    const walkthroughTime: number = walkthroughHours + walkthroughMins / 60;
    walkthroughTimeMultiplier = 1 + walkthroughTime;

    // DifficultyMultiplier
    if (!isDifficultiesCountMoreThanOne || difficulties.length === 0) {
      difficultyMultiplier = 1;
    } else {
      let totalMultiplier: number = 0;

      for (const difficulty of difficulties) {
        const {
          selectedDifficulty,
          difficultiesCount,
          selectedDifficultiesOption,
        } = difficulty;

        let multiplier: number = 1;

        if (difficultiesCount === 2) {
          multiplier =
            selectedDifficultiesOption === "NormalHard"
              ? selectedDifficulty === 1
                ? 1
                : 1.4
              : selectedDifficulty === 1
                ? 0.7
                : 1;
        } else {
          multiplier =
            0.7 +
            ((selectedDifficulty - 1) / (difficultiesCount - 1)) * (1.4 - 0.7);
        }

        totalMultiplier += multiplier;
      }

      difficultyMultiplier = totalMultiplier / difficulties.length;
    }

    // GameFAQsDifficultyMultiplier
    let voteBonus: number = 0;
    if (gamefaqsVotesCount > 1000) {
      voteBonus = 0.075;
    } else if (gamefaqsVotesCount > 250) {
      voteBonus = 0.1;
    } else if (gamefaqsVotesCount > 50) {
      voteBonus = 0.15;
    } else if (gamefaqsVotesCount > 5) {
      voteBonus = 0.175;
    } else if (gamefaqsVotesCount > 0) {
      voteBonus = 0.2;
    }

    gamefaqsDifficultyMultiplier =
      1 + (-0.2 + ((gamefaqsDifficulty - 1) / 4) * (-0.2 + 0.75)) + voteBonus;

    // MetascoreMultiplier
    metascoreMultiplier = 1 + (85 - (criticsScore + usersScore) / 2) / 150;

    // Final result
    points =
      walkthroughTimeMultiplier *
      difficultyMultiplier *
      gamefaqsDifficultyMultiplier *
      metascoreMultiplier *
      10;

    points = Math.round(points);
  }

  $: calculatePoints();
</script>

<div class="container">
  <h1>Калькулятор</h1>
  <form>
    <fieldset>
      <legend>
        Время прохождения с <a
          href="https://www.howlongtobeat.com/"
          target="_blank">HLTB</a
        >
      </legend>
      <input
        id="walkthroughHours"
        type="number"
        min="1"
        max="1000"
        bind:value={walkthroughHours}
        on:input={calculatePoints}
      />h
      <input
        id="walkthroughMins"
        type="number"
        min="0"
        max="59"
        bind:value={walkthroughMins}
        on:input={calculatePoints}
      />m
    </fieldset>

    <fieldset>
      <legend>Есть ли выбор сложности?</legend>
      <input
        id="isDifficultiesCountMoreThanOne"
        type="checkbox"
        bind:checked={isDifficultiesCountMoreThanOne}
        on:change={handleDifficultiesChange}
      />
      <label for="isDifficultiesCountMoreThanOne">Да</label>
      {#if isDifficultiesCountMoreThanOne}
        <input
          type="number"
          bind:value={difficultiesCount}
          on:input={handleDifficultiesChange}
          min="1"
          max="5"
        />
        {#each difficulties as difficulty, index}
          <DifficultySelector
            {index}
            bind:selectedDifficulty={difficulty.selectedDifficulty}
            bind:difficultiesCount={difficulty.difficultiesCount}
            bind:selectedDifficultiesOption={difficulty.selectedDifficultiesOption}
            {onDifficultyChange}
          />
        {/each}
      {/if}
    </fieldset>

    <fieldset>
      <legend>
        Сложность по <a href="https://gamefaqs.gamespot.com/" target="_blank"
          >GameFAQs</a
        >
      </legend>
      <label for="gamefaqsDifficulty">Difficulty:</label>
      <input
        id="gamefaqsDifficulty"
        type="number"
        min="1"
        max="5"
        step="0.01"
        bind:value={gamefaqsDifficulty}
        on:input={calculatePoints}
      /><br />
      <label for="gamefaqsVotesCount">Users count:</label>
      <input
        id="gamefaqsVotesCount"
        type="number"
        min="1"
        max="20000"
        bind:value={gamefaqsVotesCount}
        on:input={calculatePoints}
      />
    </fieldset>

    <fieldset>
      <legend>
        Оценки с <a href="https://www.metacritic.com/game/" target="_blank"
          >Metacritic</a
        >
      </legend>
      <label for="criticsScore">Metascore:</label>
      <input
        id="criticsScore"
        type="number"
        min="1"
        max="100"
        bind:value={criticsScore}
        on:input={calculatePoints}
      /><br />
      <label for="usersScore">User score:</label>
      <input
        id="usersScore"
        type="number"
        min="1"
        max="100"
        bind:value={usersScore}
        on:input={calculatePoints}
      />
    </fieldset>

    <fieldset>
      <legend> Итоговое количество очков </legend>
      <span id="result">{points}</span>
      <span id="multiplyers"
        >({walkthroughTimeMultiplier} * {difficultyMultiplier} * {gamefaqsDifficultyMultiplier}
        * {metascoreMultiplier}) * 10</span
      >
    </fieldset>
  </form>

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
    с<a href="https://metacritic.com/games" target="_blank">Metacritic</a>:
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

  legend {
    font-weight: bold;
  }

  fieldset {
    margin-bottom: 12px;
  }

  #result {
    font-weight: bold;
    font-size: 32px;
  }

  #multiplyers {
    /* display: none; */
    color: gainsboro;
  }
</style>
