#include <bits/stdc++.h>
#include "quiz.h"
using namespace std;

int main () {
    int tt;
    cin >> tt;
    Quiz4 q4;
    while (tt--) {
        float ACT, GPA;
        cin >> ACT >> GPA;
        q4.program(ACT, GPA);
    }

    return 0;
}