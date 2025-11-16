<h1>Loan Eligibility Expert System (GNU Prolog)</h1>
<h3>A rule-based expert system for bank loan recommendation</h3>
<br>

<h1>Project Description</h1>

<p>
This project is a rule-based expert system developed using <b>GNU Prolog</b> to recommend suitable banks for loan applicants.
The system evaluates income, loan amount, employment type, and credit history using predefined knowledge rules and logical inference.
It returns all eligible banks and also identifies the best bank with the lowest interest rate.
</p>
<br>

<h1>Overview</h1>

<p>
The system operates as an interactive questionnaire where the user enters:<br><br>
• Monthly income<br>
• Desired loan amount<br>
• Employment type<br>
• Credit history<br><br>
Based on this information, the expert system checks all banks in the knowledge base and determines eligibility.
After identifying the eligible banks, the system compares interest rates and recommends the most suitable option.
</p>
<br>

<h1>Features</h1>

<p>
• Rule-based decision-making using Prolog logic<br>
• Validates all user inputs<br>
• Checks minimum income, maximum loan amount, employment type, and credit ranking<br>
• Displays all banks that match the user profile<br>
• Recommends the best bank based on lowest interest rate<br>
• Includes a simple CLI using <code>start/0</code><br>
</p>
<br>

<h1>Knowledge Base Structure</h1>

<p>
Each bank in the system includes:<br><br>
Minimum income • Maximum loan limit • Employment types • Minimum credit score • Interest rate
</p>

<p>
<code>bank(boc, 30000, 10000000, [permanent, self_employed], good, 10.0).</code>
</p>
<br>

<h1>Important Predicates</h1>

<p>
<code>eligible_bank/5</code> – Checks if the applicant qualifies for a specific bank<br>
<code>find_all_eligible_banks/5</code> – Returns a list of all eligible banks<br>
<code>select_best_bank/3</code> – Selects the bank with the lowest interest rate<br>
<code>start/0</code> – Launches the interactive mode for user input<br>
</p>
<br>

<h1>How to Run</h1>

<p>
1.Open GNU Prolog<br>
2.Load the program: <code>?- [filename].</code><br>
3.Start the expert system: <code>?- start.</code><br>
</p>
<br>

<h1>Example Queries</h1>

<p>
<code>?- find_all_eligible_banks(50000, 400000, permanent, good, Banks).</code><br>
<code>?- select_best_bank([boc, peoples, hnb], Best, Rate).</code><br>
<code>?- start.</code>
</p>
<br>

<h1>About This Project</h1>

<p>
This system is designed for educational and academic use.
It demonstrates how Prolog can be used to build simple AI-based decision-making solutions.
The model can be expanded by adding more banks, modifying eligibility requirements, or introducing new ranking factors.
</p>
<br>

