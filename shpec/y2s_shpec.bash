library=./shpec-helper.bash
source "$library" 2>/dev/null || source "${BASH_SOURCE%/*}/$library"
unset -v library

shpec_source lib/y2s.bash

describe 'lookup'
  it "returns a scalar by name from a lookup"
    declare -A sampleh=([one]="1")
    result=''
    expected='declare -- result="1"'
    lookup sampleh.one result
    assert equal "$expected" "$(declare -p result)"
  end

  it "returns an array by name from a lookup"
    declare -A sampleh=([ones]="( 1 )")
    results=()
    expected='declare -a results='\''([0]="1")'\'
    lookup sampleh.ones results
    assert equal "$expected" "$(declare -p results)"
  end

  it "returns an array nested in an array"
    declare -A sampleh=([ones.0]="( 2 )")
    results=()
    expected='declare -a results='\''([0]="2")'\'
    lookup sampleh.ones.0 results
    assert equal "$expected" "$(declare -p results)"
  end

  it "returns an array nested in a hash"
    declare -A sampleh=([ones.twos]="( 2 )")
    results=()
    expected='declare -a results='\''([0]="2")'\'
    lookup sampleh.ones.twos results
    assert equal "$expected" "$(declare -p results)"
  end

  it "returns a hash by name from a lookup"
    declare -A sampleh=([oneh]="( [one]=1 )")
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    lookup sampleh.oneh resulth
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "returns a hash nested in an array"
    declare -A sampleh=([oneh.0]="( [one]=1 )")
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    lookup sampleh.oneh.0 resulth
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "returns a hash nested in a hash"
    declare -A sampleh=([oneh.twoh]="( [one]=1 )")
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    lookup sampleh.oneh.twoh resulth
    assert equal "$expected" "$(declare -p resulth)"
  end
end

describe '_expand_expression'
  it "transforms an expression"
    expected='^( *)([[:alnum:]_]+)[[:space:]]*:[[:space:]]*[value][[:space:]]*$'
    result=''
    _expand_expression '<indent><key> : [value] ' result
    assert equal "$expected" "$result"
  end
end

describe 'yml2struct'
  it "parses a plain scalar"
    sample='one: 1'
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a double-quoted scalar"
    sample='one: "1"'
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a single-quoted scalar"
    sample="one: '1'"
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "errors on a non-doubled single-quote in a single-quoted scalar"
    sample="one: '''"
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    assert unequal $? 0
  end

  it "errors on a plain single-quote scalar"
    sample="one: '"
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    assert unequal 0 $?
  end

  it "errors on a plain double-quote scalar"
    sample='one: "'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    assert unequal 0 $?
  end

  it "errors on a non-escaped double-quote in a double-quoted scalar"
    sample='one: """'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    assert unequal 0 $?
  end

  it "parses a plain escaped double-quote scalar"
    sample='one: \"'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    expected='declare -A resulth='\''([one]="\\\"" )'\'
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a double-quoted escaped double-quote scalar"
    sample='one: "\""'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    expected='declare -A resulth='\''([one]="\"" )'\'
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "errors on a double-quoted double-quote with a leading escaped backslash scalar"
    sample='one: "\\""'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    assert unequal $? 0
  end

  it "doesn't expand shell variables"
    one=hello
    sample='one: $one'
    declare -A resulth=()
    yml2struct resulth <<<"$sample"
    expected='declare -A resulth='\''([one]="\$one" )'\'
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a plain scalar with a space inside"
    sample='one: 1 1'
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1 1" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a double-quoted scalar with a leading space"
    sample='one: " 1"'
    declare -A resulth=()
    expected='declare -A resulth='\''([one]=" 1" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a double-quoted scalar with a trailing space"
    sample='one: "1 "'
    declare -A resulth=()
    expected='declare -A resulth='\''([one]="1 " )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a hash nested in a hash"
    read -rd '' sample <<'EOS'
oneh:
  two: 2
EOS
    declare -A resulth=()
    expected='declare -A resulth='\''([oneh.two]="2" [oneh]="([two]=\\"2\\" )" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses an array nested in a hash"
    read -rd '' sample <<'EOS'
oneh:
  - zero
EOS
    declare -A resulth=()
    expected='declare -A resulth='\''([oneh]="([0]=\\"zero\\" )" [oneh.0]="zero" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "continues parsing a hash after a nested element"
    read -rd '' sample <<'EOS'
oneh:
  two: 2
threeh:
  four: 4
EOS
    declare -A resulth=()
    expected='declare -A resulth='\''([threeh]="([four]=\"4\" )" [oneh.two]="2" [oneh]="([two]=\"2\" )" [threeh.four]="4" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses a nested hash two levels deep"
    read -rd '' sample <<'EOS'
oneh:
  twoh:
    three: 3
EOS
    declare -A resulth=()
    expected='declare -A resulth='\''([oneh.twoh.three]="3" [oneh]="([twoh.three]=\"3\" [twoh]=\"([three]=\\\"3\\\" )\" )" [oneh.twoh]="([three]=\"3\" )" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses an array"
    sample='- one'
    declare -A resulth=()
    expected='declare -A resulth='\''([0]="one" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end

  it "parses an array in an array"
    read -rd '' sample <<'EOS' ||:
-
  - zero
EOS
    declare -A resulth=()
    expected='declare -A resulth='\''([0.0]="zero" [0]="([0]=\"zero\" )" )'\'
    yml2struct resulth <<<"$sample"
    assert equal "$expected" "$(declare -p resulth)"
  end
end
