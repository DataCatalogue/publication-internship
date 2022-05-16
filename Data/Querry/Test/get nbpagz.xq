import module namespace functx = 'http://www.functx.com';

let $bnf := db:open("Database")/bnf//record//datafield[@tag='215']
let $inha := db:open("Database")/inha//record//datafield[@tag='215']
let $all := ($bnf,$inha)

let $seq := $all//subfield[@code='a']//text()
for $i in $seq
let $token := tokenize($i,'\s')
for $itoken in $token
let $n := index-of($token,$itoken)
for $ni in $n
let $list := if($itoken='p.')then($token[$ni -1])
for $il in $list
let $test := functx:get-matches($i,'\d+[^\d]?\sp\.($|^d)?')
for $t in $test 
let $etr:= functx:get-matches($t,'[0-9]+')

return ($i,$etr)
(: array{$i,$etr}:)
(:try{replace($i, '[0-9]+' , concat('<','n','>'))}catch * {$i}:)
(:[^0-9]?[0-9]+([^0-9]\s|\s)p\.:)
(::)
(:$i:)
(:try{replace($i, '[^0-9]?[0-9]+[^0-9]?p\.' , concat('<',$rslt,'>'))}catch * {$i}:)