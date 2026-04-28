#include <bits/stdc++.h>
#include "quiz.h"
using namespace std;

int main() {
    int tt;
    cin >> tt;
    Quiz1 q1;
    while (tt--) {
        long long w, x, y, z;
        cin >> w >> x >> y >> z;

        cout << q1.program(w, x, y, z) << '\n';
    }

    return 0;
}