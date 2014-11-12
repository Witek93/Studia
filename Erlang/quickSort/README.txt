To compile program start the Erlang shell:
>> erl

and there pass the files to compiling function:
>> c(vec). c(spawner). c(qsort). c(tests).


EXAMPLES:

1) Test 5 times on a default-length (500000) vector:
>> tests:test(5).

2) Test 5 times on a vector which length is 100:
>> tests:test(5,100).

3) Print times of sorting the same vector (which length is 5000) in two different ways:
>> tests:printComparison(5000).
