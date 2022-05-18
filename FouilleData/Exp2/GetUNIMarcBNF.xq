declare namespace sparql='http://www.w3.org/2005/sparql-results#';
declare namespace srw="http://www.loc.gov/zing/srw/";
declare namespace mxc="info:lc/xmlns/marcxchange-v2";
import module namespace functx = 'http://www.functx.com';
(:https://data.bnf.fr/sparql/#query=PREFIX%20rdarelationships%3A%20%3Chttp%3A%2F%2Frdvocab.info%2FRDARelationshipsWEMI%2F%3E%0APREFIX%20dcterms%3A%20%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0ASELECT%20DISTINCT%20%3FDataBNF%20%3FGalica%0AWHERE%20%7B%0A%20%3FDataBNF%20dcterms%3Asubject%20%3Chttp%3A%2F%2Fdata.bnf.fr%2Fark%3A%2F12148%2Fcb121430454%3E.%0A%20%3FDataBNF%20rdarelationships%3AelectronicReproduction%20%3FGalica%0A%7D%20%0A&endpoint=https%3A%2F%2Fdata.bnf.fr%2Fsparql&requestMethod=GET&tabTitle=Query%2011&headers=%7B%7D&contentTypeConstruct=application%2Frdf%2Bxml&contentTypeSelect=application%2Fsparql-results%2Bxml&outputFormat=response:)

let $doclist := doc('FouilleData\Exp2\SPAQL.xml')//sparql:binding[@name='DataBNF']/sparql:uri/text()

return functx:change-element-ns-deep(<bnfNUM>{
for $i in $doclist
let $ark := replace(replace($i,'http://data.bnf.fr/',''),'#about','')

return 
     http:send-request(<http:request method='get' timeout='10'/>,concat('http://catalogue.bnf.fr/api/SRU?version=1.2&amp;operation=searchRetrieve&amp;query=bib.persistentid%20any%20%22',$ark,'%22'))//mxc:record}</bnfNUM>,'info:lc/xmlns/marcxchange-v2','')