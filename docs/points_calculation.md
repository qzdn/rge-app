# Формулы расчёта количества очков за прохождение

### Главная формула:

$$
\text{score} = \left(\text{walkthroughTime}^{1.2}\right) \times \left(\text{difficultyMultiplier} + \text{timeFactor}\right)^{1.4} \times \left(\text{genreMultiplier}\right)^{1.4} \times \text{ratingMultiplier} + \text{baseValue}
$$

### Формула для расчёта коэффициента сложности:

$$
\text{difficultyMultiplier} = 
\begin{cases}
1, & \text{если } \text{difficultiesCount} = 1 \text{ или } (\text{difficultiesCount} = 2 \text{ и } \text{difficultySelected} = 1) \\
1.25, & \text{если } \text{difficultiesCount} = 2 \text{ и } \text{difficultySelected} = 2 \\
0.85 + \frac{\text{difficultySelected} - 1}{\text{difficultiesCount} - 1} \times (1.4 - 0.85), & \text{в остальных случаях}
\end{cases}
$$

### Модификатор для игр короче 5 часов:

$$
\text{timeFactor} = 1 + \max\left(0, \frac{5 - \text{walkthroughTime}}{5}\right)
$$

### Формула для множителя оценки:

$$
\text{ratingMultiplier} = 1 + \frac{85 - \frac{\text{scoreCritics} + \text{scoreUsers}}{2}}{200}
$$

### Формула для множителя сложных жанров:

$$
\text{genreMultiplier} = 1 + 0.2 \times \text{hardGenresCount}
$$


### Округление результата:

$$
\text{Итоговые очки = } \text{Math.ceil(score)}
$$
