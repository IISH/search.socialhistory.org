<?xml version="1.0" encoding="UTF-8"?>

<!--
This stylesheet corrects some irregularities from the Evergreen OAI export.
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="marc:leader">
        <xsl:variable name="tmp" select="concat(substring(text(),1, 13), '     ', substring(text(),14))"/>
        <marc:leader>
            <xsl:value-of select="substring($tmp, 1, 24)"/>
        </marc:leader>
    </xsl:template>

    <xsl:template match="marc:subfield[@code='0']"/>

</xsl:stylesheet>