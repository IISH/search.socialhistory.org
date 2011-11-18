<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                exclude-result-prefixes="ead"
        xmlns:php="http://php.net/xsl"
        >

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:apply-templates select="//ead:did/ead:unittitle[ead:unitdate]"/>
    </xsl:template>

    <xsl:template match="ead:unittitle">
        <xsl:variable name="item">
            <xsl:apply-templates/>
            <xsl:for-each select="ead:unitdate">
                    <xsl:value-of select="php:function('TimePeriods::getDates', 'info', string(text()))"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="$item"/>

    </xsl:template>

    <xsl:template match="ead:pername|ead:corpname|ead:emph">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>