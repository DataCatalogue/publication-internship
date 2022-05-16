module namespace tools= 'http://basex.org/modules/tools';

declare function tools:betweenPosition($sequence,$min,$max){
  for $i in $min to $max
      return $sequence[$i]
    };
    
declare function tools:SeqContains($sequence,$value){
  
  for $i in $sequence
       let $rslt:= map:merge(
       if ($i=$value)then(map{'true':1})
     )
   return if(map:find($rslt,'true')=1)then('true')else('false')
    };
declare function tools:remove-prefixes($node as node(), $prefixes as xs:string*) {
    typeswitch ($node)
    case element()
        return
            if ($prefixes = ('#all', prefix-from-QName(node-name($node)))) then
                element {QName(namespace-uri($node), local-name($node))} {
                    $node/@*,
                    $node/node()/tools:remove-prefixes(., $prefixes)
                }
            else
                element {node-name($node)} {
                    $node/@*,
                    $node/node()/tools:remove-prefixes(., $prefixes)
                }
    case document-node()
        return
            document {
                $node/node()/tools:remove-prefixes(., $prefixes)
            }
    default
        return $node
};