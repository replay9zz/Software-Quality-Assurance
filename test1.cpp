#include <iostream>
#include "quiz.h"
using namespace std;

int main() {
    int tt;
    cin >> tt;
    Quiz1 q1;
    while (tt--) {
        int w, x, y, z;
        cin >> w >> x >> y >> z;
        cout << q1.program(w, x, y, z) << '\n';
    }

    return 0;
}