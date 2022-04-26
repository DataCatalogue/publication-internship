declare namespace srw="http://www.loc.gov/zing/srw/";
declare namespace mxc="info:lc/xmlns/marcxchange-v2";
declare namespace http="http://expath.org/ns/http-client";

let $max:= xs:integer(xs:integer(http:send-request(<http:request method='get' timeout='10'/>,'http://catalogue.bnf.fr/api/SRU?version=1.2&amp;operation=searchRetrieve&amp;query=bib.subject%20all%20%22catalogue%20de%20vente%22')//srw:numberOfRecords)div 10)

for $idxWEb in 0 to $max
    let $website:= concat('http://catalogue.bnf.fr/api/SRU?version=1.2&amp;operation=searchRetrieve&amp;query=bib.subject%20all%20%22catalogue%20de%20vente%22&amp;startRecord=',string($idxWEb*10))
    let $x:= http:send-request(<http:request method='get' timeout='10'/>,$website)
    for $i in $x//mxc:record
    let $n:= $i//mxc:controlfield[1]
    return file:write(concat('data/Output/output_',$n,'.xml'),$i,map { "method": "xml","encoding":"UTF-8","media-type":''})