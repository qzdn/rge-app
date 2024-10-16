<script lang="ts">
  export let selectedDifficulty = 2;
  export let difficultiesCount = 3;
  export let selectedDifficultiesOption = "NormalHard";
  export let index: number;
  export let onDifficultyChange;

  $: if (difficultiesCount < selectedDifficulty) {
    selectedDifficulty = difficultiesCount;
  }
</script>

<fieldset>
  <legend>Сложность #{index + 1}</legend>

  <label for={`selectedDifficulty_${index}`}>Выбранная сложность:</label>
  <input
    id={`selectedDifficulty_${index}`}
    type="number"
    min="1"
    max={difficultiesCount}
    bind:value={selectedDifficulty}
    on:input={() => onDifficultyChange(index, selectedDifficulty, difficultiesCount, selectedDifficultiesOption)}
  />
  <br />

  <label for={`difficultiesCount_${index}`}>Количество сложностей:</label>
  <input
    id={`difficultiesCount_${index}`}
    type="number"
    min="2"
    max="50"
    bind:value={difficultiesCount}
    on:input={() => onDifficultyChange(index, selectedDifficulty, difficultiesCount, selectedDifficultiesOption)}
  />
  <br />

  <input
    id={`difficultiesEasyNormal_${index}`}
    type="radio"
    value="EasyNormal"
    bind:group={selectedDifficultiesOption}
    disabled={difficultiesCount !== 2}
    on:change={() => onDifficultyChange(index, selectedDifficulty, difficultiesCount, selectedDifficultiesOption)}
  />
  <label for={`difficultiesEasyNormal_${index}`}>Easy/Normal</label>

  <input
    id={`difficultiesNormalHard_${index}`}
    type="radio"
    value="NormalHard"
    bind:group={selectedDifficultiesOption}
    disabled={difficultiesCount !== 2}
    on:change={() => onDifficultyChange(index, selectedDifficulty, difficultiesCount, selectedDifficultiesOption)}
  />
  <label for={`difficultiesNormalHard_${index}`}>Normal/Hard</label>
</fieldset>
