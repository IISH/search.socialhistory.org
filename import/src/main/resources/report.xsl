<?xml version="1.0" encoding="UTF-8"?>

<!--
This stylesheet corrects some irregularities from the Evergreen OAI export.
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>


    <xsl:template match="marc:leader">
        <xsl:if test="string-length(text()) != 24">
            <xsl:value-of select="text()"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:controlfield[@tag='001']">
        <xsl:if test="string-length(text()) != 24">
            <xsl:value-of select="text()"/>
        </xsl:if>
    </xsl:template>

    <!-- Remove authorities -->
    <xsl:template match="marc:subfield[@code='0']"/>

</xsl:stylesheet>