<?xml version="1.0" encoding="UTF-8"?>

<!-- For the rendering see SEARCH-163
    We will return a model in json. The PHP will serialize that into an array to the view.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
                exclude-result-prefixes="*">

    <xsl:template name="row">
        <xsl:param name="key"/>
        <xsl:param name="value"/>
        <tr>
            <td valign="top">
                <xsl:call-template name="language">
                    <xsl:with-param name="key" select="normalize-space($key)"/>
                </xsl:call-template>
            </td>
            <td valign="top">
                <xsl:copy-of select="$value"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="language">
        <xsl:param name="key"/>
        <xsl:value-of select="$key"/>
    </xsl:template>

    <xsl:template match="ead:p">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:list">
        <ul>
            <xsl:apply-templates select="node()|@*"/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:item">
        <li>
            <xsl:apply-templates select="node()|@*"/>
        </li>
    </xsl:template>

    <xsl:template match="ead:row">
        <tr>
            <xsl:apply-templates select="node()|@*"/>
        </tr>
    </xsl:template>

    <xsl:template match="ead:entry">
        <td>
            <xsl:apply-templates select="node()|@*"/>
        </td>
    </xsl:template>

    <xsl:template match="ead:extref">
        <a href="{@href}" target="_blank">
            <xsl:apply-templates select="node()"/>
        </a>
    </xsl:template>

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates select="node()"/>
        </i>
    </xsl:template>

    <xsl:template match="ead:lb">
        <br/>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="ead:note">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="ead:*">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>

</xsl:stylesheet>

