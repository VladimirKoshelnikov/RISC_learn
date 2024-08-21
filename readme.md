
 # Архитектура репозитория
- src/                         - исходный код компонентов ядра;
- src/firmware                 - hex-файлы прошивки;
- testbench/                   - исходный код тестовых окружений;
- images/                      - Картинки используемые в репозитории;
- makefile                     - сборщик проекта.

# Описание репозитория

В репозитории представлена реализация процессора из книги "Цифровой синтез RISC-V" под редакцией Ю. Романова. 

![RISC-V Architecture](images/book.jpg)

В книге реализован упрощенный вариант RISC-V процессора с минимальным набором ассемблерных команд, которых достаточно для назождения квадратного корня. В процессе реализации было решено расширить используемый набор команд до стандартного набора инструкций RV32I без учета функции системного вызова **ecall** и системного останова **ebreak**.  

![RV32-I Instruction set](images/Risc-V_Reference.png)

Получившаяся архитектура ядра:

![RISC-V Architecture](images/RISC_Architecture.png)

# Программное окружение

|       Наименование:       |           Значение:         |
|---------------------------|-----------------------------|
|   Операционная система    |   Elementary OS 7.1 Horus   |
|   Компилятор/Синтезатор   |        Vivado 2021.1        |
| Просмотр выходных файлов  | GTK-Wave Analyzer v.3.3.104 |

