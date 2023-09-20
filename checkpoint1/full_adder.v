module full_adder(sum, cout, a, b, cin);
	input a, b, cin;
	output sum, cout;
	wire tmp1, tmp2, tmp3;
	xor func1(tmp1, a, b);
	xor func2(sum, tmp1, cin);
	and func3(tmp2, tmp1, cin);
	and func4(tmp3, a, b);
	or func5(cout, tmp2, tmp3);
endmodule
