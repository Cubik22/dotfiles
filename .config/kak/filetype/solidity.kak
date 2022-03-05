# https://github.com/ethereum/solidity

## detection

hook global BufCreate .*[.](sol) %{
    set-option buffer filetype solidity
}

## initialization

hook global WinSetOption filetype=solidity %{
    require-module solidity
    set-option window static_words %opt{solidity_static_words}
}

hook -group solidity-highlight global WinSetOption filetype=solidity %{
    add-highlighter window/solidity ref solidity
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/solidity }
}

hook global BufSetOption filetype=solidity %{
    set-option buffer comment_line '//'
    set-option buffer comment_block_begin '/*'
    set-option buffer comment_block_end '*/'
}

provide-module solidity %§

## highlighters

add-highlighter shared/solidity                 regions
add-highlighter shared/solidity/code            default-region group
add-highlighter shared/solidity/single_string   region "'" (?<!\\)(\\\\)*' fill string
add-highlighter shared/solidity/double_string   region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/solidity/comment         region '//' '$' fill comment
add-highlighter shared/solidity/comment_line    region '///' '$' fill comment
add-highlighter shared/solidity/comment_region  region /[*] [*]/ fill comment

# integer formats
add-highlighter shared/solidity/code/ regex '(?i)\b0b[01]+l?\b' 0:value
add-highlighter shared/solidity/code/ regex '(?i)\b0x[\da-f]+l?\b' 0:value
add-highlighter shared/solidity/code/ regex '(?i)\b0o?[0-7]+l?\b' 0:value
add-highlighter shared/solidity/code/ regex '(?i)\b([1-9]\d*|0)l?\b' 0:value
# float formats
add-highlighter shared/solidity/code/ regex '\b\d+[eE][+-]?\d+\b' 0:value
add-highlighter shared/solidity/code/ regex '(\b\d+)?\.\d+\b' 0:value
add-highlighter shared/solidity/code/ regex '\b\d+\.' 0:value

# operator symbols
add-highlighter shared/solidity/code/ regex (!|\||&|%|~|\^|\*|/|\+|-|\?|:|\;|=|>|<|>=|<=|\*=|/=|\+=|-=) 0:operator

evaluate-commands %sh{
    # grammar

    values="true false wei szabo finney ether
    seconds minutes hours days weeks years
    now super block msg now tx this abi"

    meta="delete new var return import pragma"

    spec="dev title author notice param return"

    keywords="anonymous as assembly break case catch constant
    continue default do else emit enum external final for
    if in indexed inline internal is let match memory
    modifier of payable private public pure relocatable
    returns static storage struct throw try type typeof
    using view while immutable calldata
    override virtual after alias apply auto copyof define
    implements macro mutable null partial promise reference
    sealed sizeof supports switch typedef unchecked"

    types="mapping address bool
    int int8 int16 int24 int32 int40 int48 int56 int64 int72 int80
    int88 int96 int104 int112 int120 int128 int136 int144 int152
    int160 int168 int178 int184 int192 int200 int208 int216
    int224 int232 int240 int248 int256
    uint uint8 uint16 uint24 uint32 uint40 uint48 uint56 uint64
    uint72 uint80 uint88 uint96 uint104 uint112 uint120 uint128
    uint136 uint144 uint152 uint160 uint168 uint178 uint184
    uint192 uint200 uint208 uint216 uint224 uint232 uint240
    uint248 uint256
    fixed ufixed
    string string1 string2 string3 string4 string5 string6 string7
    string8 string9 string10 string11 string12 string13 string14
    string15 string16 string17 string18 string19 string20 string21
    string22 string23 string24 string25 string26 string27 string28
    string29 string30 string31 string32
    byte bytes bytes1 bytes2 bytes3 bytes4 bytes5 bytes6 bytes7
    bytes8 bytes9 bytes10 bytes11 bytes12 bytes13 bytes14 bytes15
    bytes16 bytes17 bytes18 bytes19 bytes20 bytes21 bytes22
    bytes23 bytes24 bytes25 bytes26 bytes27 bytes28 bytes29
    bytes30 bytes31 bytes32"

    attributes="blockhash require revert assert sha3 keccak256 sha256
    ripemd160 ecrecover addmod mulmod selfdestruct"

    methods="constructor function fallback receive
    abstract contract library interface event error"

    functions="stop add sub mul div sdiv mod smod exp not lt gt slt
    sgt eq iszero and or xor shl shr sar
    signextend jump jumpi pop mload mstore mstore8 sload
    sstore calldataload calldatacopy codecopy extcodesize
    extcodecopy returndatacopy extcodehash create create2
    call callcode delegatecall staticcall
    log0 log1 log2 log3 log4 swap dup
    pc msize gas caller callvalue calldatasize codesize
    returndatasize origin gasprice coinbase timestamp
    number difficulty gaslimit"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list solidity_static_words $(join "${values} ${meta} ${keywords} ${types} ${attributes} ${methods} ${functions}" ' ')"

    # highlight keywords
    printf %s "
        add-highlighter shared/solidity/code/ regex '\b($(join "${values}" '|'))\b' 0:value
        add-highlighter shared/solidity/code/ regex '\b($(join "${meta}" '|'))\b' 0:meta
        add-highlighter shared/solidity/code/ regex '@\b($(join "${spec}" '|'))\b' 0:meta
        add-highlighter shared/solidity/code/ regex '\b($(join "${keywords}" '|'))\b' 0:keyword
        add-highlighter shared/solidity/code/ regex '\b($(join "${types}" '|'))\b' 0:type
        add-highlighter shared/solidity/code/ regex '\b($(join "${attributes}" '|'))\b' 0:attribute
        add-highlighter shared/solidity/code/ regex '\bdef\s+($(join "${methods}" '|'))\b' 1:builtin
        add-highlighter shared/solidity/code/ regex '\b($(join "${functions}" '|'))\b\(' 1:function
    "
}

§
