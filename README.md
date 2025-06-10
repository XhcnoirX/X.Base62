# X.Base62

Base62 encoder and decoder written in InterSystems ObjectScript. Base62 uses all lowercase and uppercase characters plus all digits to encode data (26 + 26 + 10 = 62), as opposed to Base64 which also includes + and / as its encoding set, and whch also uses = for padding (no padding needed with Base62).

For more information, see for instance [this article](https://codefarm0.medium.com/understanding-base62-base64-and-other-encodings-a-developers-guide-e9eeabbaabbf).

This implementation is based on [tuupola's base62 library](https://github.com/tuupola/base62).

## Methods
Note the methods below are all class methods and therefore should be executed directly on the X.Base62 class.

### Encode( data As %String [, range As %String ] ) As %String

Encode *data* into its Base62 form. If *range* is supplied, it needs to be 62 characters long. In that case *range* will be used as the 62 character range used for encoding rather than the default range.

### Decode( encData As %String [, range As %String ] ) As %String

Decode *encData* into its original form. If the original data was encoded using a custom *range* (see Encode above), this *range* needs to be supplied as well with this call to make sure *decData* can be correctly decoded.

### EncodeInteger( data As %Integer [, range As %String ] ) As %String

Encode *data* into its Base62 form. If *range* is supplied, it needs to be 62 characters long. In that case *range* will be used as the 62 character range used for encoding rather than the default range.

### DecodeInteger( encData As %String [, range As %String ] ) As %Integer

Decode *encData* into its original form. If the original data was encoded using a custom *range* (see EncodeInteger above), this *range* needs to be supplied as well with this call to make sure *decData* can be correctly decoded.

## Usage
To encode & decode given data to a Base62 string:
```
USER>set encData = ##class(X.Base62).Encode("This data to be encoded!")
 
USER>write encData
uSfea3iX7g9dPkqil2xd8OcGrXaqTNHF
USER>write ##class(X.Base62).Decode(encData)
This data to be encoded!
```
To encode & code given integer data to a Base62 string:
```
USER>set encInteger = ##class(X.Base62).EncodeInteger(1234567890)
 
USER>w encInteger
1LY7VK
USER>w ##class(X.Base62).DecodeInteger(encInteger)
1234567890
```
