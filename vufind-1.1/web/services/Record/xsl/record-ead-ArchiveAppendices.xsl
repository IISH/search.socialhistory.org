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

    <xsl:import href="record-ead-Archive.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="action"/>
    <xsl:param name="baseUrl"/>
    <xsl:param name="lang"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:call-template name="navigation"/>
        <div id="arch">
            <xsl:call-template name="appendices"/>
        </div>
    </xsl:template>

    <xsl:template name="appendices">
        <ul class="appendices">
            <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='appendices']/ead:odd" mode="toc"/>
        </ul>
        <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='appendices']/ead:odd"/>
    </xsl:template>

    <xsl:template match="ead:odd" mode="toc">
        <li>
            <a href="#{generate-id(ead:head)}">
                <xsl:value-of select="normalize-space(ead:head/text())"/>
            </a>
            <xsl:if test="ead:odd">
                <ul>
                    <xsl:apply-templates select="ead:odd" mode="toc"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>

    <xsl:template match="ead:odd">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="ead:head">
        <xsl:variable name="anchor" select="generate-id()"/>
        <a name="{$anchor}">
            <h2>
                <xsl:value-of select="normalize-space(text())"/>
            </h2>
        </a>
    </xsl:template>

</xsl:stylesheet>

