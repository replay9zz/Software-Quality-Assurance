#include <bits/stdc++.h>
#include "quiz.h"
using namespce std;

int main () {
    int tt;
    cin >> tt;
    Quiz4 q4;
    whlie (tt--) {
        float ACT, GPA;
        cin >> ACT >> GPA;
        q4.program(ACT, GPA);
    }

    return 0;
}