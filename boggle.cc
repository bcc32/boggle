#include <algorithm>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#define NUM_MOVES 8
using namespace std;

const int moves[NUM_MOVES][2] =
{
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1}, {0, 1},
    {1, -1}, {1, 0}, {1, 1}
};

inline bool cmp(string a, string b) {
    return a.size() < b.size();
}

bool match(vector<string> board, string word);
bool search(vector<string> board, vector< vector<bool> > visited,
        int i, int j, string word);

int main(int argc, char *argv[]) {
    string filename = "wordlist";
    if (argc >= 2)
        filename = argv[1];

    ifstream dict(filename.c_str());

    vector<string> words;

    int n, m;
    cin >> n >> m;

    vector<string> board(n);
    for (int i = 0; i < n; i++)
        cin >> board[i];

    string word;
    for (dict >> word; !dict.eof(); dict >> word)
        if (word.size() >= m && match(board, word))
            words.push_back(word);

    sort(words.rbegin(), words.rend(), cmp);

    for (vector<string>::iterator it = words.begin(); it != words.end(); ++it)
        cout << *it << endl;

    dict.close();
}

bool match(vector<string> board, string word) {
    int dim = board.size();
    vector< vector<bool> > visited(dim);
    for (int i = 0; i < dim; i++)
        visited[i].resize(dim);

    for (int i = 0; i < dim; i++)
        for (int j = 0; j < dim; j++)
            if (search(board, visited, i, j, word))
                return true;
    return false;
}

bool search(vector<string> board, vector< vector<bool> > visited,
        int i, int j, string word) {
    int dim = board.size();
    if (word.size() == 0)
        return true;
    else if (i < 0 || i >= dim || j < 0 || j >= dim)
        return false;
    else if (visited[i][j])
        return false;
    else if (board[i][j] != word[0])
        return false;
    else if (word[0] == 'q' && word[1] != 'u')
        return false;
    visited[i][j] = true;
    for (int m = 0; m < NUM_MOVES; m++)
        if (search(board, visited, i + moves[m][0], j + moves[m][1],
                word[0] == 'q' ? word.substr(2) : word.substr(1)))
            return true;
    return false;
}
