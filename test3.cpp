#include <bits/stdc++.h>
#include "quiz.h"
using namespace std;

int main() {
    int tt;
    cin >> tt;
    Quiz3 q3;
    while (tt--) {
        int x, y;
        cin >> x >> y;
        cout << q3.program(x, y) << '\n';
    }

    return 0;
}