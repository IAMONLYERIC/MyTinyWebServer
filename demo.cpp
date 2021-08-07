#include <iostream>
#include <vector>
#include <string>
#include <cstring>

using namespace std;

enum class Enumeration1
{
    Val1, // 0
    Val2, // 1
    Val3 = 100,
    Val4 /* = 101 */
};
vector<string> splitWithStl(string str, string pattern);
int main()
{
    Enumeration1 e1 = Enumeration1::Val2;
    cout << (int)e1 << endl;

    return 0;
}
