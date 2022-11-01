<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

<!--Making a copy of the original text with all nodes and attributes  -->
    <xsl:template match="@*|node()" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

<!--person and place lists sorted by their string length to target full names e.g. (Bartolome de Albornoz). 
    See files: "placeName_list.xml", "persName_list.xml"-->

    <xsl:variable name="places" select="doc('placeName_list.xml')//name"/>
    <xsl:variable name="placesSorted" as="xs:string*">
        <xsl:for-each select="$places">
            <xsl:sort order="descending" select="string-length(.)"/>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="persons" select="doc('persName_list.xml')//name"/>
    <xsl:variable name="personsSorted" as="xs:string*">
        <xsl:for-each select="$persons">
            <xsl:sort order="descending" select="string-length(.)"/>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>

<!-- Entries separated by pipe | to make them look like regular expressions -->

    <xsl:variable name="regex1" select="string-join($personsSorted, '|')"/>
    <xsl:variable name="regex2" select="string-join($placesSorted, '|')"/>
    
<!-- Tagging persons and places as <name type="person"> and <name type="place"> respectively based on the imported lists: "placeName_list.xml", "persName_list.xml" 
        //note//text() was excluded, it can be included though. -->
    
    <xsl:template match="tei:text//text()[not(ancestor::tei:note)]">
        <xsl:analyze-string select="." regex="{($regex1),($regex2)}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="matches(.,$regex1)">
                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                           <xsl:attribute name="type" select="'person'"/>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="matches(.,$regex2)">
                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select="'place'"/>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                 <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>

