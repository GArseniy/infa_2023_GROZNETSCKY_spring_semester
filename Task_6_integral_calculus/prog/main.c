#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include "functions.h"


unsigned long long ITER_CNT = 0;
#define NUL_ITER_CNT ITER_CNT = 0
#define INC_ITER_CNT ++ITER_CNT
#define GET_ITER_CNT ITER_CNT


//Constants:
double LEFT_BOUND = 0.1, RIGHT_BOUND = 6;
double EPS1 = 0.001 / 6, EPS2 = 0.00001;


//CMD commands:
void points(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]);

void iterations(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]);

void area(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]);

void test(int argc, char *argv[]);

void help(__attribute__((unused)) int argc, char *argv[]);


char *COMMANDS_NAMES[] = {"points", "iterations", "area", "test", "help"};

void (*COMMANDS[])(int, char **) = {points, iterations, area, test, help};

int COMMANDS_CNT = sizeof(COMMANDS) / sizeof(COMMANDS[0]);


typedef double (*function)(double x);


double root(function f, function df, function g, function dg, double a, double b, double eps) {
    // Calculation of the intersection point of functions: f(x), g(x) — on segment [a, b]
    // with sufficient precision: eps — using the Newton's Method

    double x_prev = (f(a) - g(a)) * (df(a) - dg(a)) > 0 ? b : a;
    double x = x_prev - (f(x_prev) - g(x_prev)) / (df(x_prev) - dg(x_prev));

    while (fabs(x_prev - x) > eps) {
        x_prev = x;
        x = x - (f(x) - g(x)) / (df(x) - dg(x));
        INC_ITER_CNT;
    }

    return x;
}


double parabolic_integral_sum(function f, double a, double b, int n) {
    // Calculation of the parabolic integral sum of function f(x) on segment [a, b]

    const double h = (b - a) / n;
    double sum1 = 0, sum2 = 0;

    for (int i = 1; i < n; i += 2) {
        sum1 += f(a + i * h);
        sum2 += f(a + (i + 1) * h);
    }

    return h / 3 * (f(a) + 4 * sum1 + 2 * sum2);
}


double integral(function f, double a, double b, double eps) {
    // Calculation of the integral of function f(x) on segment [a, b]
    // with sufficient precision: eps — using the Simpson's Method
    // and Runge rule with constant p = 1/15
    double p = 15;
    int n = 10;

    double s_prev = parabolic_integral_sum(f, a, b, n);
    double s = s_prev + 2 * eps / p;

    while (p * fabs(s - s_prev) > eps) {
        s_prev = s;
        n *= 2;
        s = parabolic_integral_sum(f, a, b, n);
    }

    return s;
}


char *name_pars(char *name) {
    char *ret = name;

    while (*name) {
        if (*name == '\\' || *name == '/') {
            ret = name + 1;
        }
        ++name;
    }

    return ret;
}


void points(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]) {
    double x12 = root(f_1, df_1, f_2, df_2, LEFT_BOUND, RIGHT_BOUND, EPS2);
    double x13 = root(f_1, df_1, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);
    double x23 = root(f_2, df_2, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);

    double y12 = f_1(x12);
    double y13 = f_1(x13);
    double y23 = f_2(x23);

    printf("Intersections points are:\n"
           "(x12, y12) = (%.5f, %.5f)\n"
           "(x13, y13) = (%.5f, %.5f)\n"
           "(x23, y23) = (%.5f, %.5f)\n",
           x12, y12, x13, y13, x23, y23);
}


void iterations(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]) {
    NUL_ITER_CNT;
    root(f_1, df_1, f_2, df_2, LEFT_BOUND, RIGHT_BOUND, EPS2);
    unsigned long long cnt12 = GET_ITER_CNT;

    NUL_ITER_CNT;
    root(f_1, df_1, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);
    unsigned long long cnt13 = GET_ITER_CNT;

    NUL_ITER_CNT;
    root(f_2, df_2, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);
    unsigned long long cnt23 = GET_ITER_CNT;

    printf("Count of iterations for calculation intersection points:\n"
           "x12 count = %llu\n"
           "x13 count = %llu\n"
           "x23 count = %llu\n",
           cnt12, cnt13, cnt23);
}


void area(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[]) {
    double x12 = root(f_1, df_1, f_2, df_2, LEFT_BOUND, RIGHT_BOUND, EPS2);
    double x13 = root(f_1, df_1, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);
    double x23 = root(f_2, df_2, f_3, df_3, LEFT_BOUND, RIGHT_BOUND, EPS2);

    double s = 0;

    s += integral(f_1, x13, x12, EPS1);
    s -= integral(f_2, x23, x12, EPS1);
    s -= integral(f_3, x13, x23, EPS1);

    printf("An area of the figure is:\n"
           "\tS = %.3f\n", s);
}


void test(int argc, char *argv[]) {
    char *name = name_pars(argv[0]);

    function f_[] = {0, f_1, f_2, f_3};
    function df_[] = {0, df_1, df_2, df_3};

    if (argc > 2 && !strcmp(argv[2], "root")) {
        if (argc != 10) {
            printf("%s: 'root' have 7 args\n", name);
            return;
        }

        char *buf_pointer = 0;
        printf("%s:\n"
               "\troot(%s, %s, %s, %s, %s, %s, %s);\n"
               "\treturn:\t%.5f;\n", name,
               argv[3], argv[4], argv[5], argv[6], argv[7], argv[8], argv[9],
               root(f_[strtol(argv[3] + 2, &buf_pointer, 10)], df_[strtol(argv[4] + 3, &buf_pointer, 10)],
                    f_[strtol(argv[5] + 2, &buf_pointer, 10)], df_[strtol(argv[6] + 3, &buf_pointer, 10)],
                    strtod(argv[7], &buf_pointer), strtod(argv[8], &buf_pointer), strtod(argv[9], &buf_pointer)));
        return;
    }

    if (argc > 2 && !strcmp(argv[2], "integral")) {
        if (argc != 7) {
            printf("%s: 'integral' have 4 args\n", name);
            return;
        }

        char *buf_pointer = 0;
        printf("%s:\n"
               "\tintegral(%s, %s, %s, %s);\n"
               "\treturn:\t%.5f;\n", name,
               argv[3], argv[4], argv[5], argv[6],
               integral(f_[strtol(argv[3] + 2, &buf_pointer, 10)],
                        strtod(argv[4], &buf_pointer), strtod(argv[5], &buf_pointer), strtod(argv[6], &buf_pointer)));
        return;
    }

    if (argc > 2 && !strcmp(argv[2], "help")) {
        printf("There are %s functions: \n"
               "\troot\t\t(function) f_[...] (function) df_[...] (function) f_[...] (function) df_[...] (double) a (double) b (double) eps\n"
               "\tintegral\t(function) f_[...] (double) a (double) b (double) eps\n", name);
        return;
    }


    if (argc > 2) {
        printf("%s: '%s' is not a %s function. See '%s %s help'\n",
               name, argv[2], name, name, argv[1]);
    } else {
        printf("Enter the name of the function after '%s %s' to test it and then its arguments separated by a space.'\n"
               "To see %s functions type '%s %s help'\n",
               name, argv[1], name, name, argv[1]);
    }
}


void help(__attribute__((unused)) int argc, char *argv[]) {
    printf("There are common %s commands used in various situations:\n"
           "\ttest\t\tTest of program functions\n"
           "\tpoints\t\tShow points of intersection\n"
           "\tarea\t\tShow an area of the figure\n"
           "\titerations\tShow count of iterations for calculating intersection points\n"
           "\n"
           "\thelp\t\tShow help information\n",
           name_pars(argv[0]));
}


void no_command(__attribute__((unused)) int argc, char *argv[]) {
    char *name = name_pars(argv[0]);
    printf("%s: '%s' is not a %s command. See '%s help'\n",
           name, argv[1], name, name);
}


int main(int argc, char *argv[]) {
    if (argc == 1) {
        help(argc, argv);
        return 0;
    }

    for (int i = 0; i < COMMANDS_CNT; ++i) {
        if (!strcmp(argv[1], COMMANDS_NAMES[i])) {
            COMMANDS[i](argc, argv);
            return 0;
        }
    }

    no_command(argc, argv);
    return 0;
}
