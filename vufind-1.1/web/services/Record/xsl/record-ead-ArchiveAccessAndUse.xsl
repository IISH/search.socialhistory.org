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
    <xsl:output method="html" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="action"/>
    <xsl:param name="baseUrl"/>
    <xsl:param name="lang"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:call-template name="navigation"/>
        <table>
            <xsl:call-template name="access"/>
            <xsl:call-template name="userestrict"/>
            <xsl:call-template name="prefercite"/>
            <xsl:call-template name="otherfindaid"/>
        </table>
    </xsl:template>

    <xsl:template name="access">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveAccessAndUse.access'"/>
            <xsl:with-param name="value">
               <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='access_and_use']/ead:accessrestrict/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="userestrict">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveAccessAndUse.userestrict'"/>
            <xsl:with-param name="value">
               <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='access_and_use']/ead:userestrict/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="prefercite">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveAccessAndUse.prefercite'"/>
            <xsl:with-param name="value">
               <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='access_and_use']/ead:prefercite/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="otherfindaid">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveAccessAndUse.otherfindaid'"/>
            <xsl:with-param name="value">
               <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='access_and_use']/ead:otherfindaid/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>

