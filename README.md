# An example of list based Name Entity Annotation in TEI-tite texts.
Early Modern Spanish in The School of Salamanca.

**Work:** Albornoz, Arte de los contractos (2020 [1573]), in: The School of Salamanca. A Digital Collection of Sources <https://id.salamanca.school/texts/W0017>

**Goal:** Name Entity Annotation in Early Modern Spanish coded in TEI-tite texts (input and output).

## Preliminary challenges:

Regarding the language. Early Modern Spanish did not follow any spelling standard and do not have specific NLP libraries to process such text.

1. All words could be spelled differently, capitalized or not. It means many variables of the same word were considered correct.
Names of people and places were not exceptions. e.g., :

	*Babilonia or Babylonia 
	Eſpaña, Heſpaña, Hespaña*

	Thus, a regular expression like ```(\s)([A-Z]+\w+)(\s)``` finds capitalized words. However, it does not only find words like *Pedro*, but also words like *Prologo*.

	Similarly, compound names could be found by using:

	```xml
	(\s)([A-Z]+\w+)(\s)de(\s)([A-Z]+\w+)(\s)
	``` 
	
	It actually finds names as *Bartolome de Albornoz*, yet some other false positives as titles *Action de Compra*. 

2. Abbreviations enabled printers saving paper and ink, expensive items back then. 
Name Entities were also written differently following this purpose. For instance, *Fernando* was shortened by *Fernãdo* and *Valencia* by *Valẽcia*, yet all these words could be found in the same text.

3. Printing errors and OCR/double-Key transcriptions typos may also affect tagging, e. g., : *And**u**luzia* printed or typed instead of *Andaluzia*.

4. Technical limitations.

Input and output should be kept in the same format and should contain all annotation/enrichment.
It means, texts are coded in TEI-tite (XML) and the output should retain the previous format and annotations, after a Name Entity Tagging process.

These challenges led to self-tailored lists and **XSL-Transformation** using **analyze-string**.

## XSL-Transformation 

The stylesheet makes first a copy of the input (TEI-tite-xml document), see *Transformation.xsl* :
    
    <!--Making a copy of the original text with all nodes and attributes  -->
    <xsl:template match="@*|node()" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:copy>
    	<xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    </xsl:template>
    
The function ``xsl:analyze-string`` looks for substrings based on regular expressions and annotate matching strings.

	<xsl:template match="tei:text//text()[not(ancestor::tei:note)]">
        <xsl:analyze-string select="." regex="{($regex1),($regex2)}">

In this case, these regular expressions correspond to the exact strings of person and place names, which are stored in xml files as lists (see persName_list.xml and  placeName_list.xml):

	<?xml version="1.0" encoding="UTF-8"?> 
	<root>
	<name>Iohã</name>
	<name>Adam</name>[...]

Then, these entries are linked as variables in the stylesheet:

	<!-- Entries separated by pipe | to make them look like regular expressions -->
    <xsl:variable name="regex1" select="string-join($personsSorted, '|')"/>
    <xsl:variable name="regex2" select="string-join($placesSorted, '|')"/>

All entities listed here were extracted from some of our works in early modern Spanish, and are sorted case-sensitive according to their descending length. It means, long strings e.g., *Bartolome de Albornoz* comes first in the list, and *Bartolome* alone later. 
This enables more accuracy by tagging names composed of two or more words.

## Output

Entities from the lists are annotated in the output file as ``<name type="person">`` and ``<name type="place">`` respectively keeping previous annotations and format. See the files *Input_TEI-tite.xml* and *Output_TEI-tite.xml*. Example:

Input:

    <p part="N">
    <lb/><hi rend="init">D</hi>On Phelippe por la gracia de Dios Rey
    <lb/>de Caſtilla, de Leon [...]
    
Output:

    <p part="N">
    <lb/><hi rend="init">D</hi>On <name type="person">Phelippe</name> por la gracia de Dios Rey
    <lb/>de <name type="place">Caſtilla</name>, de <name type="place">Leon</name> [...]

## To improve

Our texts are usually long and have complex structures. Many words are hyphenated and/or separated by elements like ``<pb/>, <cb/>,<lb/>, <note>, <milestone>``: 

	<lb/>El Doctor Franci<lb type="nb"/>ſco de Auedillo. [...]

	<lb/>A el II. Puncto, ſi Domingo deue algo a Ca<note rend="noRef" type="margin" xml:id="W0017_note0311b">
	<lb/>Reſpueſta
	<lb/>del II puc-<lb type="nb"/>cto.</note><lb type="nb"/>talina por eſte Contracto, digo que no, por
	
Here the entities *Franciſco* and *Catalina* are separated by hyphen and marginal note respectevely. These "string interference" prevents the function ``xsl:analyze-string`` to find the string.

We look forward to receiving suggestions on how to deal with these challenges :)
