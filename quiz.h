#include <iostream>

class Quiz1 {
public:
    int program(int w, int x, int y, int z) {
        int sum = w + x + y + z;
        if (w >= 90 || x >= 90) {
            sum += 10;
        }
        if (y <= 30 && z <= 30) {
            sum -= 5;
        }

        return sum;
    }
};

class Quiz2 {
public:
    void program(int X, int Y) {
        if (2 < X && X < 30 && 1 < Y && Y < 50) {
            std::cout << X * Y << '\n';
        }
        else {
            std::cout << "Invalid" << '\n';
        }
    }
};

class Quiz3 {
public:
    int program(int x, int y) {
        int z = 0;
        if (x > 0 && y > 0) {
            z = 100;
        }

        return z;
    }
};

class Quiz4 {
public:
    void program(float ACT, float GPA) {
        if ((ACT <= 36 && GPA <= 4.0) && (10 * GPA + ACT >= 71)) {
            std::cout << "OK" << '\n';
        }
        else {
            std::cout << "NG" << '\n';
        }
    }
};
