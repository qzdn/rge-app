# Расчёт количества очков за прохождение игры

### Основная формула:

$$
Points = \left( WalkthroughTimeMultiplier \times DifficultyMultiplier \times HardGenresMultiplier \times MetascoreMultiplier \right) \times 10
$$

Итоговый результат округляется до целого числа в большую сторону:

$$
\lceil 68.5562 \rceil = 69
$$

### 1. Множитель времени прохождения:

Время прохождения игры (${WalkthroughTime}$) берётся с [HLTB](https://howlongtobeat.com/):

$$
WalkthroughTime = Hours + \frac{Mins}{60}
$$
  
$$
WalkthroughTimeMultiplier = \left( WalkthroughTime \right)^{0.9}
$$

### 2. Множитель сложности:

Условия для множителя сложности:

$$
DifficultyMultiplier =
\begin{cases}
1, & \text{если открыта только одна сложность или возможность выбора отсутствует} \\
1, & \text{если 2 уровня сложности Easy/Normal или Normal/Hard, выбран Normal} \\
0.7, & \text{если 2 уровня сложности (Easy/Normal), выбран Easy} \\
1.5, & \text{если 2 уровня сложности (Normal/Hard), выбран Hard} \\
0.7 + \left( \frac{SelectedDifficulty - 1}{DifficultiesCount - 1} \right) \times (1.5 - 0.7), & \text{если уровней сложности > 2}
\end{cases}
$$

Если в игре множественный выбор сложности (например, как в Silent Hill 2 - сложность боя и сложность загадок), то множитель высчитывается как среднее арифметическое значение:

$$
\overline{DifficultyMultiplier} = \frac{DifficultyMultiplier_{1} + DifficultyMultiplier_{2} + \dots + DifficultyMultiplier_{n}}{n}
$$

### 3. Множитель сложных жанров:

Если игра содержит сложные жанры (Bullet hell, Shoot 'em up, Roguelike, RTS, JRPG, Souls-like, Metroidvania, Puzzle):

$$
HardGenresMultiplier = 1 + \left( 0.7 \times HardGenresCount \right)
$$

### 4. Множитель рейтинга:

Множитель рейтинга рассчитывается на основе среднего балла критиков и юзеров с сайта [Metacritic](https://metacritic.com/games):

$$
MetascoreMultiplier = 1 + \frac{85 - \left( \frac{CriticsScore + UsersScore}{2} \right)}{100}
$$
