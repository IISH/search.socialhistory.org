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
        <div id="arch"><table>
            <xsl:call-template name="bibliographical"/>
            <xsl:call-template name="custodhist"/>
            <xsl:call-template name="arrangement"/>
            <xsl:call-template name="content"/>
            <xsl:call-template name="processinfo"/>
            <xsl:call-template name="altformavail"/>
            <xsl:call-template name="originalsloc"/>
            <xsl:call-template name="relatedmaterial"/>
            <xsl:call-template name="separatedmaterial"/>
        </table></div>
    </xsl:template>

    <xsl:template name="bibliographical">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.bibliographical'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='context']/ead:bioghist/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="custodhist">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.custodhist'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='context']/ead:custodhist/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="content">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.content'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates
                        select="ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:scopecontent/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="arrangement">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.arrangement'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates
                        select="ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:arrangement/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="processinfo">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.processinfo'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates
                        select="ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:processinfo/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="altformavail">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.altformavail'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='allied_materials']/ead:altformavail/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="originalsloc">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.originalsloc'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='allied_materials']/ead:originalsloc/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="relatedmaterial">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.relatedmaterial'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ead:archdesc/ead:descgrp[@type='allied_materials']/ead:relatedmaterial/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="separatedmaterial">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveContentAndStructure.separatedmaterial'"/>
            <xsl:with-param name="value">
                <xsl:apply-templates
                        select="ead:archdesc/ead:descgrp[@type='allied_materials']/ead:separatedmaterial/*"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>

