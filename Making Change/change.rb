#!/usr/bin/env ruby

def make_change(amount, coins = [25,10,5,1])
	coins.sort.reverse.
		collect{
			|coin| 
			f = amount/coin; 
			amount %= coin; 
			Array.new(f) {coin} 
		}.flatten
end

p make_change(95)
