#include <cstdlib>
#include <iostream>
#include <sstream>
#include <fstream>
#include <random>
#include "bigint.hpp"


std::string to_str(unsigned int val) {
    std::stringstream stream;
    stream << val;
    return stream.str();
}


bool check_mul(const char *filename, unsigned a, unsigned b, unsigned c) {
    BigInt big_a(to_str(a)), big_b(to_str(b)), big_c(to_str(c));

    BigInt result = big_a * big_b * big_c;

    std::ofstream fout("data.txt");
    fout << a << ' ' << b << ' ' << c;
    fout.close();

    FILE * inp = freopen("data.txt", "r", stdin);
    FILE *fp = freopen("result.txt", "w", stdout);

    system(filename);
    fclose(fp);
    fclose(inp);

    std::ifstream fin("result.txt");
    std::string result_str;
    std::getline(fin, result_str);
    fin.close();

    std::stringstream stream;
    stream << result;
    std::string my_str = stream.str();

    std::ofstream log("log.txt");

    if (my_str != result_str)
    {
        log << a << " " << b << " " << c << "\n";
        log << "Right: " << my_str << "\n" << "My___: " << result_str << "\n";
        return false;
    }

    return true;
}


int main() {
    std::random_device rd;   // non-deterministic generator
    std::mt19937 gen(rd());  // to seed mersenne twister.
    std::uniform_int_distribution<> dist(-2147483648, 2147483647);


    for (int i = 0; i < 10000; i++)
    {
        auto res = check_mul("C:\\SASMprog.exe", dist(gen), dist(gen), dist(gen));
        if (not res)
        {
            break;
        }
    }

    return 0;
}
