<?xml version="1.0" encoding="UTF-8"?>

<!--
Select deleted records
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="marc:record">
        <xsl:choose>
            <xsl:when test="marc:controlfield[@tag='008']"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- stretch leaders -->
    <xsl:template match="marc:leader">
        <marc:leader>
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(text()))=24">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="tmp" select="concat(substring(text(),1, 13), '     ', substring(text(),14))"/>
                    <xsl:value-of select="substring($tmp, 1, 24)"/>
                </xsl:otherwise>
            </xsl:choose>
        </marc:leader>
    </xsl:template>

    <!-- remove empty datafields -->
    <xsl:template match="marc:datafield[not(marc:subfield)]"/>

    <!-- Remove empty codes -->
    <xsl:template match="marc:datafield[marc:subfield[not(text())]]"/>

    <!-- Remove authorities -->
    <xsl:template match="marc:subfield[@ode='0']"/>

</xsl:stylesheet>