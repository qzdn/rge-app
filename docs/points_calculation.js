"use strict";

function calculateScore() {
  // Получаем значения из полей формы
  const walkthroughHours =
    parseInt(document.getElementById("walkthroughHours").value) || 1;
  const walkthroughMins =
    parseInt(document.getElementById("walkthroughMins").value) || 0;
  const isDifficultiesCountMoreThanOne =
    document.getElementById("isDifficultiesCountMoreThanOne").checked || false;
  const selectedDifficulty =
    parseInt(document.getElementById("selectedDifficulty").value) || 2;
  const difficultiesCount =
    parseInt(document.getElementById("difficultiesCount").value) || 3;
  const difficultiesEasyNormal =
    document.getElementById("difficultiesEasyNormal").checked || false;
  const difficultiesNormalHard =
    document.getElementById("difficultiesNormalHard").checked || false;
  const criticsScore =
    parseInt(document.getElementById("criticsScore").value) || 85;
  const usersScore =
    parseInt(document.getElementById("usersScore").value) || 85;

  // WalkthroughTimeMultiplier
  const walkthroughTime = walkthroughHours + walkthroughMins / 60;
  const walkthroughTimeMultiplier = Math.pow(walkthroughTime, 0.9);

  // DifficultyMultiplier
  let difficultyMultiplier;
  if (!isDifficultiesCountMoreThanOne) {
    difficultyMultiplier = 1;
  } else if (difficultiesCount == 2) {
    if (difficultiesEasyNormal) {
      difficultyMultiplier = selectedDifficulty == 1 ? 0.7 : 1;
    } else if (difficultiesNormalHard) {
      difficultyMultiplier = selectedDifficulty == 1 ? 1 : 1.5;
    }
  } else {
    difficultyMultiplier =
      0.7 + ((selectedDifficulty - 1) / (difficultiesCount - 1)) * (1.5 - 0.7);
  }

  // HardGenresMultiplier
  let selectedGenres = [
    { checked: document.getElementById("genre1").checked, weight: 0.7 }, // Bullet hell
    { checked: document.getElementById("genre2").checked, weight: 0.6 }, // Tactical RPG
    { checked: document.getElementById("genre3").checked, weight: 0.5 }, // RTS, Roguelike, JRPG, Shoot 'em up
    { checked: document.getElementById("genre4").checked, weight: 0.4 }, // Souls-like
    { checked: document.getElementById("genre5").checked, weight: 0.2 }, // Metroidvania, Puzzle / Quest
  ];

  let selectedHardGenres = selectedGenres.reduce((total, genre) => {
    return genre.checked ? total + genre.weight : total;
  }, 0);

  const hardGenresMultiplier = 1 + selectedHardGenres;

  // MetascoreMultiplier
  const metascoreMultiplier = 1 + (85 - (criticsScore + usersScore) / 2) / 150;

  // Финальный расчёт
  const points =
    walkthroughTimeMultiplier *
    difficultyMultiplier *
    hardGenresMultiplier *
    metascoreMultiplier *
    10;

  // Вывод результата
  document.getElementById("result").textContent = `${Math.ceil(points)}`;
}

function enableDifficultiesControls() {
  if (document.getElementById("isDifficultiesCountMoreThanOne").checked) {
    document.getElementById("difficultiesCount").disabled = false;
    document.getElementById("selectedDifficulty").disabled = false;
    if (document.getElementById("difficultiesCount").value == 2) {
      document.getElementById("difficultiesEasyNormal").disabled = false;
      document.getElementById("difficultiesNormalHard").disabled = false;
    }
  } else {
    document.getElementById("difficultiesCount").disabled = true;
    document.getElementById("selectedDifficulty").disabled = true;
    document.getElementById("difficultiesEasyNormal").disabled = true;
    document.getElementById("difficultiesNormalHard").disabled = true;
  }
}

function enableTwoDifficultiesControls() {
  if (
    document.getElementById("difficultiesCount").value == 2 &&
    document.getElementById("isDifficultiesCountMoreThanOne").checked
  ) {
    document.getElementById("difficultiesEasyNormal").disabled = false;
    document.getElementById("difficultiesNormalHard").disabled = false;
  } else {
    document.getElementById("difficultiesEasyNormal").disabled = true;
    document.getElementById("difficultiesNormalHard").disabled = true;
  }
}
