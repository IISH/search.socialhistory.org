<?xml version="1.0" encoding="UTF-8"?>

<!--
Select deleted records
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:output method="text"/>

    <xsl:template match="marc:record">
        <xsl:choose>
            <xsl:when test="marc:controlfield[@tag='008']"/>
            <xsl:otherwise>
                <xsl:value-of select="marc:controlfield[@tag='001']"/>
<xsl:text>
</xsl:text>
                <xsl:value-of select="marc:datafield[@tag='902']/marc:subfield[@code='a']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>