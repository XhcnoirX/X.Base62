/// Base62 encoder and decoder
/// With separate encoder/decoder for integers (as opposed to a string containing an integer)
/// 
/// @see https://github.com/tuupola/base62
Class X.Base62 Extends %RegisteredObject
{

Parameter RANGE As %String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

ClassMethod Encode(input As %String = "", range As %String = "") As %String
{
	set range = ..SetRange(range)
	set data = []
	for i=1:1:$l(input) {
		do data.%Push($ascii($e(input, i)))
	}
	set data = ..FromBaseToBase(.data, 256, 62)
	set output = ""
	for i=data.%Size()-1:-1:0 {
		set output = output _ $e(range, data.%Get(i) + 1)
	}
	quit output
}

ClassMethod Decode(input As %String = "", range As %String = "") As %String
{
	set range = ..SetRange(range)
	do ..ValidateInput(input, range)
	set data = []
	for i=1:1:$l(input) {
		do data.%Push($find(range, $e(input, i)) - 2)
	}
	set data = ..FromBaseToBase(.data, 62, 256)
	set output = ""
	for i=data.%Size()-1:-1:0 {
		set output = output _ $char(data.%Get(i))
	}
	quit output
}

ClassMethod EncodeInteger(input As %Integer = 0, range As %String = "") As %String
{
	set range = ..SetRange(range)
	set data = []
	do data.%Push(input)
	set data = ..FromBaseToBase(.data, 10, 62)
	set output = ""
	for i=data.%Size()-1:-1:0 {
		set output = output _ $e(range, data.%Get(i) + 1)
	}
	quit output
}

ClassMethod DecodeInteger(input As %String = "", range As %String = "") As %Integer
{
	set range = ..SetRange(range)
	do ..ValidateInput(input, range)
	set data = []
	for i=1:1:$l(input) {
		do data.%Push($find(range, $e(input, i)) - 2)
	}
	set data = ..FromBaseToBase(.data, 62, 10)
	set output = 0
	for i=data.%Size()-1:-1:0 {
		set output = output*10 + data.%Get(i)
	}
	quit output
}

ClassMethod SetRange(range As %String = "") As %String [ Private ]
{
	if range'="" {
		if $l(range)'=62 {
			set $zerror = "Supplied range is not of length 62!"
			throw
		}
		for i=1:1:61 {
			if $e(range, i+1, *)[$e(range,i) {
				set $zerror = "Supplied range does not contain 62 unique characters!"
				throw
			}
		}
		quit range
	}
	quit ..#RANGE
}

ClassMethod FromBaseToBase(ByRef arr As %DynamicArray, from As %Integer, to As %Integer) As %DynamicArray [ Private ]
{
	set output = []
	set count = arr.%Size()
	while count>0 {
		set quotient = []
		set remainder = 0
		for i=1:1:count {
			set accumulator = arr.%Get(i-1) + (remainder*from)
			set remainder = ##class(X.Utils).Modulo(accumulator, to)
			set digit = (accumulator - remainder) / to
			if quotient.%Size() || (digit>0) {
				do quotient.%Push(digit)
			}
		}
		do output.%Push(remainder)
		set arr = quotient
		set count = arr.%Size()
	}
	quit output
}

ClassMethod ValidateInput(input As %String = "", range As %String = "") [ Private ]
{
	set range = ..SetRange(range)
	for i=1:1:$l(input) {
		if range'[$e(input, i) {
			set $zerror = "Data contains invalid characters"
			throw
		}
	}
}

}
