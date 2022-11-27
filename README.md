# Архитектура вычислительных систем
## Индивидуальное домашнее задание №3
### Вариант 26

### Вишняков Родион Сергеевич 
##### группа БПИ213
###### 27 ноября 2022 г.
[![Typing SVG](https://readme-typing-svg.herokuapp.com?color=%2336BCF7&lines=Faculty+of+Computer+science+student)](https://git.io/typing-svg)


Задание: Разработать программу вычисления корня пятой степени согласно быстро сходящемуся итерационному алгоритму определения корня n-той степени с точностью не хуже 0,1%.

### Отчёт

### 10 баллов

#### Выполнено:
 - исходный код на си, скомпилированный с разными опциями, шаги рефакторинга ассемблероного кода пропущены т.к. писалась программа на ассемблере с нуля.
 - сравнительные тесты показывающие скорость работы обоих программ.
 - генератор случайных чисел с указанием границ
 - ввод-вывод из файла
 - измерение времени работы программы
 - текст программы на языке ассемблера без использования си функций
 - ассемблерный код содержит поясняющие комментарии

#### Что где лежит?
В папке "10" находятся все необходимые файлы на эту оценку.
В "10" -> "lib" можно найти 
 - array.s (работа с массивами)
 - math.s (функции для вычисления)
 - io.s (input & output)
 - str.s (работа со строками)
 - time.s (Измерение времени выполнения)
 - rand.s (Рандомная генерация)
В "10" -> "main.s" можно найти программа написанная "вручную"
В файлах:
 - 8.c находится реализация алгоритма на Си, где присутсвует обработка всех возможных вводов и выводов данных, замеры веремни и генерация рандомных значений
  - 8.s находится скомпилированная программа на ассемблере из Си (8.с), где убраны все лишние макросы, программа скомпилирована с помощью команды: 
`gcc -masm=intel -fno-asynchronous-unwind-tables -fno-jump-tables -fno-stack-protector -fno-exceptions -S 8.c`
 - 8-ref.s находится программа после рефакторинга, где максимально замещена работа со стеком на работу с регистрами.

#### Как запустить программу на 10?
![img](/p16.png)
Для компиляции и построения программы был написан Makefile, введи последовательно эти команды:
#### *make compile*
#### *make build*

Далее необходимо ввести *./main _*, на месте _ введите необходимый ключ:
 - ключ -с (ввод искомого значения из командой строки)
 - ключ -f input.txt output.txt (ввод из входного файла и запись результата в выходной файл) 
 (!!!ВАЖНО, после ввода числа в файл input.txt нажмите enter!!!)
 - ключ -r N M(где N нижняя граница генерации рандомного числа, а М - верхняя)
 
 #### Как запустить программу на 8?
![img](/p17.png)
Введите эту команду:
#### *gcc 8.c*

Далее были реализованы разные способы ввода:
#### *./a.out* (ключь, который соответсвует способу ввода)

#### if argv[1] == "-r") -> random
#### else if argv[1] == "-h" -> help вывод всех ключей с обозначениями
#### else if argv[1] == "-f" -> input.txt output.txt
#### else if argv[1] == "-s" -> ввод из командной строки

Также модификация программы на C и программы на ассемблере, полученной после рефакторинга, для проведения сравнения на производительность.
#### start = clock()
#### end = clock()
#### (double)(end - start) / (CLOCKS_PER_SEC)
 
#### Размер 
Размер .s файла полученного после компиляции с помощью флагов *-masm=intel -fno-asynchronous-unwind-tables -fno-jump-tables -fno-stack-protector -fno-exceptions -Os* состовляет 473 строки, в то время когда с оптимизацией -Ofast 452 строки. В то же время размер программы написанной "вручную" состовляет 405 строк в main файле + 1146 строк в вспомогательных файлах, которые лежат в папке lib. Но размер ассемблер файла состовляет 14,7K, а у программы на си 20K, даже учитывая флаг -Os.
#### main.s - 405 lines (372 sloc)  9.56 KB
#### 8.c - 95 lines (92 sloc)  2.4 KB
#### 8.s - 473 lines (473 sloc)  8.71 KB
#### 8-ref.s - 482 lines (482 sloc)  8.38 KB

#### Функциональность:

mabs()  - функция принимает на вход double x. Функция возвращает модуль этого числа x.

root_res() - функция принимает double num, над которой производятся вычисления корня пятой степени согласно быстро сходящемуся итерационному алгоритму определения корня n-той степени с точностью не хуже 0,1%.
![img](/p15.png)

Я разделил код ассемблера на файл с функциями и файл с main. Далее скомпилировал полученные файлы и запустил файлы с исходными данными и файла для вывода результатов с использованием аргументов командной строки.


Для проверки ввести команды:
#### gcc 8-1.s 8-2.s
#### gcc ./a.out

### Тестовые покрытия файлов

Файл | Тест           | Результат | Соотвествие 
-----------|----------------|:---------:|------------:
8.c     | 32    | 2 |        True | 
8.s     | 32    | 2 |        True |
8.c     | 243	   | 3 |       True      |
8.s     | 243   | 3 |       True      |
8.c     | 100	  | 2.512 |      True       |
8.s     | 100	  | 2.512 |     True        |
8.c     | 150   | 2.724 |      True       |
8.s     | 150	  | 2.724 |     True        |


Файл | Тест           | Результат | Соотвествие
-----------|----------------|:---------:|------------:
8.s     | 32   | 2 |        True | 
main.s     | 32    | 2 |        True |
8-ref.s     | 32	   | 2 |       True      |
8.s     | 243    | 3 |       True      |
main.s     | 243 	   | 3 |      True       |
8-ref.s       | 243	   | 3 |     True        |
8.s     | 100	  | 2.512 |      True       |
main.s     | 100		  | 2.512 |     True        |
8-ref.s    | 100		  | 2.512 |     True        |

![img](/p18.png)
