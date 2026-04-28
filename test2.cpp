#include <iostream>
#include "quiz.h"
using namespace std;

int main() {
    int tt;
    cin >> tt;
    Quiz2 q2;
    while (tt--) {
        int X, Y;
        cin >> X >> Y;
        q2.program(X, Y);
    }

    return 0;
}