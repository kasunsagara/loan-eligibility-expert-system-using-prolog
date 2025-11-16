% ============================================================
% Loan Eligibility Expert System
% Developed in GNU Prolog
% ============================================================

% -------------------------------
% Knowledge Base - Banks
% -------------------------------

bank(boc,       30000, 10000000, [permanent, self_employed], good,      10.0).
bank(peoples,   30000, 8000000, [permanent, self_employed, temporary], average, 14.0).
bank(hnb,       100000, 5000000, [permanent], good,                    18.8).
bank(commercial,75000,5000000, [permanent, self_employed], excellent, 15.85).
bank(seylan,    200000, 7000000, [permanent, temporary], average,      17.3).

% -------------------------------
% Credit ranking (numeric values for comparison)
% -------------------------------
credit_value(poor, 1).
credit_value(average, 2).
credit_value(good, 3).
credit_value(excellent, 4).

% -------------------------------
% Utility predicates
% -------------------------------

% check_credit_at_least(UserCredit, MinCredit)
% True if user's credit ranking >= MinCredit ranking.
check_credit_at_least(UserCredit, MinCredit) :-
    credit_value(UserCredit, ValU),
    credit_value(MinCredit, ValM),
    ValU >= ValM.

% eligible_bank(+Income, +LoanAmount, +Employment, +Credit, -Bank)
% True if the given applicant data satisfies Bank's conditions.
eligible_bank(Income, LoanAmount, Employment, Credit, Bank) :-
    bank(Bank, MinIncome, MaxLoan, EmploymentList, MinCredit, _Rate),
    Income >= MinIncome,
    LoanAmount =< MaxLoan,
    member(Employment, EmploymentList),
    check_credit_at_least(Credit, MinCredit).

% find_all_eligible_banks(+Income, +LoanAmount, +Employment, +Credit, -Banks)
find_all_eligible_banks(Income, LoanAmount, Employment, Credit, Banks) :-
    findall(Bank, eligible_bank(Income, LoanAmount, Employment, Credit, Bank), BanksUnsorted),
    sort(BanksUnsorted, Banks).  % remove duplicates and sort

% -------------------------------
% Best bank selection (based on lowest interest rate)
% -------------------------------

% prepare_rate_pairs(+Banks, -Pairs)
prepare_rate_pairs([], []). 
prepare_rate_pairs([B|Bs], [Rate-B|Pairs]) :-
    bank(B, _MinInc, _MaxLoan, _EmpList, _MinCred, Rate),
    prepare_rate_pairs(Bs, Pairs).

% select_best_bank(+Banks, -BestBank, -BestRate)
select_best_bank([], none, infinite) :- !.
select_best_bank(Banks, BestBank, BestRate) :-
    prepare_rate_pairs(Banks, Pairs),
    keysort(Pairs, Sorted),
    Sorted = [BestRate-BestBank | _].

% -------------------------------
% Interactive Interface (start/0)
% -------------------------------

start :-
    nl, write('----------------------------------------------'), nl,
    write('Loan Eligibility Expert System (GNU Prolog)'), nl,
    write('Enter applicant details when prompted.'), nl, nl,

    % ---- Income input ----
    write('Please enter monthly income (number).'), nl,
    write('Income = '), read(Income), nl,

    (   number(Income) ->
        (   Income < 30000 ->
                write('❌ Your income should be higher to apply for a loan. (Min 30 000/=)'), nl,
                write('System stopped due to low income.'), nl, !
            ;
                % Continue only if income >= 30000
                write('Please enter desired loan amount (number).'), nl,
                write('LoanAmount = '), read(LoanAmount), nl,

                write('Enter employment type (one of: permanent, self_employed, temporary, unemployed).'), nl,
                write('Employment = '), read(Employment), nl,

                write('Enter credit history (one of: poor, average, good, excellent).'), nl,
                write('Credit = '), read(Credit), nl,

                % ---- Validate Inputs ----
                ( number(LoanAmount) -> true ; write('ERROR: Loan amount should be a number.'), nl, !, fail ),
                ( member(Employment, [permanent, self_employed, temporary, unemployed]) -> true ;
                    write('ERROR: Invalid employment type.'), nl, !, fail ),
                ( member(Credit, [poor, average, good, excellent]) -> true ;
                    write('ERROR: Invalid credit history value.'), nl, !, fail ),

                nl, write('Checking eligibility across banks...'), nl, nl,

                % ---- Eligibility Process ----
                find_all_eligible_banks(Income, LoanAmount, Employment, Credit, EligibleBanks),
                ( EligibleBanks = [] ->
                    write('Sorry — no banks match your profile based on current rules.'), nl,
                    write('You may try adjusting loan amount or contact banks for special consideration.'), nl
                ;
                    write('✅ You are eligible at the following banks:'), nl,
                    print_bank_list(EligibleBanks), nl,
                    select_best_bank(EligibleBanks, BestBank, BestRate),
                    ( BestBank = none ->
                        write('No best bank found.'), nl
                    ;
                        write('>> Recommended (Best) Bank: '), write(BestBank),
                        write(' (Interest Rate: '), write(BestRate), write('%)'), nl
                    )
                ),
                write('----------------------------------------------'), nl, !
            )
    ;
        write('ERROR: Income should be a number.'), nl, !, fail
    ).

% -------------------------------
% Helper: Print Bank List
% -------------------------------
print_bank_list([]).
print_bank_list([B|Bs]) :-
    bank(B, MinIncome, MaxLoan, EmpList, MinCredit, Rate),
    write('- '), write(B), write(': MinIncome='), write(MinIncome),
    write(', MaxLoan='), write(MaxLoan), write(', Employment='), write(EmpList),
    write(', MinCredit='), write(MinCredit), write(', InterestRate='), write(Rate), write('%'), nl,
    print_bank_list(Bs).

% -------------------------------
% Example Test Queries:
% -------------------------------
% ?- start.
% ?- find_all_eligible_banks(50000, 400000, permanent, good, Banks).
% ?- select_best_bank([boc,hnb,peoples,seylan], Best, Rate).
% ============================================================