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

Если игра содержит сложные жанры, то множитель рассчитывается следующим образом:

$$
HardGenresMultiplier = 1 + 
\left( 
\sum_{i=1}^{5}{Weight}_i \times {Selected}_i 
\right)
$$

Где веса для жанров следующие:

$$
\begin{aligned}
\text{Weight}_1 &= 0.7, & \text{(Bullet hell)} \\
\text{Weight}_2 &= 0.6, & \text{(Tactical RPG)} \\
\text{Weight}_3 &= 0.5, & \text{(RTS, Roguelike, JRPG, Shoot 'em up)} \\
\text{Weight}_4 &= 0.4, & \text{(Souls-like)} \\
\text{Weight}_5 &= 0.2, & \text{(Metroidvania, Puzzle / Quest)} \\
\end{aligned}
$$

Каждый жанр учитывается, если он выбран:

$$
Selected_i = 1
$$ 

В противном случае 

$$
Selected_i = 0
$$ 

### 4. Множитель рейтинга:

Множитель рейтинга рассчитывается на основе среднего балла критиков и юзеров с сайта [Metacritic](https://metacritic.com/games):

$$
MetascoreMultiplier = 1 + \frac{85 - \left( \frac{CriticsScore + UsersScore}{2} \right)}{100}
$$
