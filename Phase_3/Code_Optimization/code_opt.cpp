#include <bits/stdc++.h>
using namespace std;

void get_data(vector<string> &vect)
{

    fstream newfile;
    newfile.open("inp.txt", ios::in);
    if (newfile.is_open())
    {
        string tp;
        while (getline(newfile, tp))
        {
            vect.push_back(tp);
        }
        newfile.close();
    }

    // for(int i=0;i<vect.size();i++){
    //     cout<<vect[i]<<"\n";
    // }
}

void simple_tokenizer(string &op, string &arg1, string &arg2, string &res, const string s)
{
    stringstream ss(s);
    string word;
    // while (ss >> word) {
    //     cout << word << endl;
    // }
    ss >> op;
    ss >> arg1;
    ss >> arg2;
    ss >> res;

    return;
}

bool is_digit(const std::string &s)
{
    return !s.empty() && std::find_if(s.begin(),
                                      s.end(), [](unsigned char c) { return !std::isdigit(c); }) == s.end();
}

int to_num(string s)
{

    stringstream a(s);

    int val;

    a >> val;
    return val;
}

int eval(string arg1, string arg2, string op)
{

    stringstream s1(arg1);
    stringstream s2(arg2);

    int val1, val2;
    s1 >> val1;
    s2 >> val2;

    if (op == "+")
    {
        return val1 + val2;
    }

    else if (op == "-")
    {
        return val1 - val2;
    }

    else if (op == "*")
    {
        return val1 * val2;
    }

    else if (op == "/")
    {
        return val1 / val2;
    }

    return -1;
}

int main()
{

    vector<string> vect;

    get_data(vect);

    vector<string> oprs = {"+", "-", "*", "/"};
    vector<string> all_op = {"+", "-", "*", "/", "==", "<=", "<", ">", ">="};
    map<string, int> m;
    vector<vector<string>> constantfolded;
    vector<string> label = {"if", "goto", "label", "not"};

    cout << "Quadruple form after Constant Folding\n";
    cout << "-------------------------------------\n";

    for (int i = 0; i < vect.size(); i++)
    {

        string op, arg1, arg2, res;
        simple_tokenizer(op, arg1, arg2, res, vect[i]);
        // cout<<op<<"\t"<<arg1<<"\t"<<arg2<<"\t"<<res<<"\n";

        if (find(oprs.begin(), oprs.end(), op) != oprs.end())
        {

            if (is_digit(arg1) && is_digit(arg2))
            {
                int result = eval(arg1, arg2, op);
                // cout<<result<<"\n";
                m[res] = result;
                cout << "=\t" << result << " NULL " << res << "\n";
                vector<string> temp = {"=", to_string(result), "NULL", res};
                constantfolded.push_back(temp);
            }

            else if (is_digit(arg1))
            {

                if (m.find(arg2) != m.end())
                {

                    int result = eval(arg1, to_string(m[arg2]), op);
                    m[res] = result;
                    cout << "=\t" << result << " NULL " << res << "\n";
                    vector<string> temp = {"=", to_string(result), "NULL", res};

                    constantfolded.push_back(temp);
                }
                else
                {
                    cout << op << " " << arg1 << " " << arg2 << " " << res << "\n";
                    vector<string> temp = {op, arg1, arg2, res};
                    constantfolded.push_back(temp);
                }
            }

            else if (is_digit(arg2))
            {

                if (m.find(arg1) != m.end())
                {

                    int result = eval(to_string(m[arg1]), arg2, op);
                    m[res] = result;
                    cout << "=\t" << result << " NULL " << res << "\n";
                    vector<string> temp = {"=", to_string(result), "NULL", res};

                    constantfolded.push_back(temp);
                }
                else
                {
                    cout << op << " " << arg1 << " " << arg2 << " " << res << "\n";
                    vector<string> temp = {op, arg1, arg2, res};
                    constantfolded.push_back(temp);
                }
            }

            else
            {

                int flag1 = 0;
                int flag2 = 0;
                string arg1Res = arg1;

                if (m.find(arg1) != m.end())
                {
                    arg1Res = to_string(m[arg1]);
                    flag1 = 1;
                }
                string arg2Res = arg2;
                if (m.find(arg2) != m.end())
                {
                    arg2Res = to_string(m[arg2]);
                    flag2 = 1;
                }

                if (flag1 == 1 && flag2 == 1)
                {
                    int result = eval(arg1Res, arg2Res, op);
                    m[res] = result;
                    cout << "=\t" << result << " NULL " << res << "\n";
                    vector<string> temp = {"=", to_string(result), "NULL", res};
                    constantfolded.push_back(temp);
                }

                else
                {
                    cout << op << "\t" << arg1Res << " " << arg2Res << " " << res << "\n";
                    vector<string> temp = {op, arg1Res, arg2Res, res};
                    constantfolded.push_back(temp);
                }
            }
        }

        else if (op == "=")
        {

            if (is_digit(arg1))
            {
                m[res] = to_num(arg1);
                cout << "=\t" << arg1 << " NULL " << res << "\n";
                vector<string> temp = {"=", arg1, "NULL", res};
                constantfolded.push_back(temp);
            }

            else
            {

                if (m.find(arg1) != m.end())
                {
                    cout << "=\t" << m[arg1] << " NULL " << res << "\n";
                    vector<string> temp = {"=", to_string(m[arg1]), "NULL", res};
                    constantfolded.push_back(temp);
                }
            }
        }

        else
        {
            cout << op << " " << arg1 << " " << arg2 << " " << res << "\n";
            vector<string> temp = {op, arg1, arg2, res};
            constantfolded.push_back(temp);
        }
    }

    // cout<<"Constant folding ---------\n";

    // for(int i=0;i<constantfolded.size();i++){
    //     for(int j=0;j<constantfolded[i].size();j++){
    //     cout<<constantfolded[i][j]<<"\t";

    //     }

    //     cout<<"\n";
    // }

    cout << "--------------------------\n";

    cout << "\n";
    cout << "Constant folded expression - \n";
    cout << "-----------------------------\n";

    for (int i = 0; i < constantfolded.size(); i++)
    {

        if (constantfolded[i][0] == "=")
        {
            cout << constantfolded[i][3] << "\t" << constantfolded[i][0] << " " << constantfolded[i][1] << "\n";
        }

        else if (find(all_op.begin(), all_op.end(), constantfolded[i][0]) != all_op.end())
        {
            cout << constantfolded[i][3] << "\t= " << constantfolded[i][1] << " " << constantfolded[i][0] << " " << constantfolded[i][2] << "\n";
        }

        else if (find(label.begin(), label.end(), constantfolded[i][0]) != label.end())
        {

            if (constantfolded[i][0] == "if")
            {
                cout << constantfolded[i][0] << " " << constantfolded[i][1] << " goto " << constantfolded[i][3] << "\n";
            }

            if (constantfolded[i][0] == "goto")
            {
                cout << constantfolded[i][0] << " " << constantfolded[i][3] << "\n";
            }

            if (constantfolded[i][0] == "label")
            {
                cout << constantfolded[i][3] << ":\n";
            }
            if (constantfolded[i][0] == "not")
            {
                cout << constantfolded[i][3] << "=" << constantfolded[i][0] << constantfolded[i][1] << "\n";
            }
        }
    }

    cout << "\n";
    cout << "After Dead Code elimination - \n";
    cout << "------------------------------\n";

    for (int i = 0; i < constantfolded.size(); i++)
    {

        if (constantfolded[i][0] == "=")
        {
            continue;
        }

        else if (find(all_op.begin(), all_op.end(), constantfolded[i][0]) != all_op.end())
        {
            cout << constantfolded[i][3] << "\t= " << constantfolded[i][1] << " " << constantfolded[i][0] << " " << constantfolded[i][2] << "\n";
        }

        else if (find(label.begin(), label.end(), constantfolded[i][0]) != label.end())
        {

            if (constantfolded[i][0] == "if")
            {
                cout << constantfolded[i][0] << " " << constantfolded[i][1] << " goto " << constantfolded[i][3] << "\n";
            }

            if (constantfolded[i][0] == "goto")
            {
                cout << constantfolded[i][0] << " " << constantfolded[i][3] << "\n";
            }

            if (constantfolded[i][0] == "label")
            {
                cout << constantfolded[i][3] << ":\n";
            }
            if (constantfolded[i][0] == "not")
            {
                cout << constantfolded[i][3] << " = " << constantfolded[i][0] << constantfolded[i][1] << "\n";
            }
        }
    }

    return 0;
}