Alice
Bob
Charlie
David
Eve

Team Alice chain adds their costs together to produce a quote.
Team Bob does the same. 
The last member of Alice's team then forwards the total quote to the team lead Charlie.
Bob's team does the same, forwarding the quote to David.
Charlie and David then inform Eve of the quote.
Eve informs Charlie of the outcome depending on whether she accepts David's proposal. If David's is lower she accepts that and then rejects Charlie.

[
    [
        A_1 -> A_2 : q_acc;
        A_2 -> ... : q_acc;
        ... -> A_n : q_acc;
        A_n -> C : quote;
    ]
    &[
        B_1 -> B_2 : q_acc;
        B_2 -> ... : q_acc;
        ... -> B_n : q_acc;
        B_n -> D : quote;
    ]
]
;[
    C -> E : quote;
    D -> E : quote;
    E -> C : {
        E -> D   : accept ; reject
        | E -> D : reject ; accept
    }
]
