An example of list based Name Entity Annotation in TEI-tite texts.
Early Modern Spanish in The School of Salamanca.

Work: Albornoz, Arte de los contractos (2020 [1573]), in: The School of Salamanca. A Digital Collection of Sources <https://id.salamanca.school/texts/W0017>

Cindy Rico Carmona
Digital Humanities Researcher

Goal:
Name Entity Annotation (Early Modern Spanish) in TEI-tite (input and output).

Preliminary challenges:

Regarding the language. Early Modern Spanish did not follow any spelling standard and do not have specific NLP libraries to process such text.

1. All words could be spelled differently, capitalized or not. It means many variables of the same word were considered correct.
Names of people and places were not exceptions. e.g.,

	Babilonia or Babylonia 
	Eſpaña, Heſpaña, Hespaña

	Thus, a regular expression, which follows capitalized words would not work properly: for instance.

	(\s)([A-Z]+\w+)(\s) it does not only find Entities like Pedro, but also words like "Prologo".

	Nor similar compound names

	(\s)([A-Z]+\w+)(\s)de(\s)([A-Z]+\w+)(\s)

	It actually finds names as "Bartolome de Albornoz", yet some other false positives as "Action de Compra". 

2. Abbreviations enabled printers saving paper and ink, expensive items back then. 
Name Entities were also written differently following this purpose.

	Fernando was shortened by Fernãdo, yet both words can be found in the same text.

	Valẽcia
	Valencia

3. Printing and OCR/double-Key transcriptions errors.

Anduluzia instead of Andaluzia


4. current technology limitations.

Input and output should be kept in the same format and should contain all annotation/enrichment.
It means, texts are transcribed in TEI-tite (XML) and a name entity recognition process the output should be kept the same format.

These challenges led to a first self-tailored test:

XSL-Transformation 

The stylesheet makes a copy of the input (TEI-tite-xml document) annotating person and place names based on lists. 

The function analyze-string can search and annotate strings based on regular expressions. 

In this case, these regular expressions correspond to exact strings of person and place names, which are stored in xml lists. 

All Entities listed were extracted from works in the corpus and are called case-sensitive according to their descending length. 
It means, composed names are searched first. E.g., "Bartolome de Albornoz" comes first in the list and "Bartolome" later. 
This enables more accuracy by tagging names composed of two or more words.

To improve:

Entities (tokens) separated by Elements like <lb/> or <note>. 

<lb/>El Doctor Franci<lb type="nb"/>ſco de Auedillo.

<lb/>A el II. Puncto, ſi Domingo deue algo a Ca<note rend="noRef" type="margin" xml:id="W0017_note0311b">
<lb/>Reſpueſta
<lb/>del II puc-<lb type="nb"/>cto.</note><lb type="nb"/>talina por eſte Contracto, digo que no, por
