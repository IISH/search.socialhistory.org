<?xml version="1.0" encoding="UTF-8"?>

<!-- For the rendering see SEARCH-163
    We will return a model in json. The PHP will serialize that into an array to the view.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
                exclude-result-prefixes="xsl ead xsi">

    <xsl:import href="record-ead-Archive.xsl"/>
    <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="action"/>
    <xsl:param name="baseUrl"/>
    <xsl:param name="lang"/>
    <xsl:param name="title"/>

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
        <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='appendices']/ead:odd"/>
    </xsl:template>

    <xsl:template match="ead:odd">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:head">
        <h2>
            <xsl:call-template name="aname">
                <xsl:with-param name="value">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:with-param>
                <xsl:with-param name="tag" select="'1'"/>
            </xsl:call-template>
        </h2>
    </xsl:template>

</xsl:stylesheet>

