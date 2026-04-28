#include <iostream>
#include "quiz.h"
using namespace std;

int main () {
    int tt;
    cin >> tt;
    Quiz4 q4;
    while (tt--) {
        float ACT, GPA;
        cin >> ACT >> GPA;
        cout << q4.program(ACT, GPA) << '\n';
    }

    return 0;
}