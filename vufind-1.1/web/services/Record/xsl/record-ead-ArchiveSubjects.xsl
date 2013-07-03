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
    <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8" indent="no"/>
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
            <table>
                <xsl:call-template name="geogname"/>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="geogname">
        <xsl:variable name="value">
            <xsl:for-each
                    select="ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:controlaccess/ead:controlaccess/ead:geogname">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$value">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveSubjects.geogname'"/>
                <xsl:with-param name="value">
                    <ul>
                        <xsl:copy-of select="$value"/>
                    </ul>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>

