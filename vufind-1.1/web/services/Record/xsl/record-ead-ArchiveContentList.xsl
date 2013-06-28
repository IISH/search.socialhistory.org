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
        <div id="arch">
            <table class="citation">
                <xsl:call-template name="contentlist"/>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="contentlist">
        <xsl:apply-templates select="ead:archdesc/ead:dsc/ead:c01"/>
    </xsl:template>

    <xsl:template
            match="ead:c01|ead:c02|ead:c03|ead:c04|ead:c05|ead:c06|ead:c07|ead:c08|ead:c09|ead:c10|ead:c11|ead:c12">
        <xsl:variable name="level" select="substring(local-name(),2)"/>
        <xsl:choose>
            <xsl:when test="@level = 'series' or @level = 'subseries'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="offset">
                    <xsl:call-template name="parent">
                        <xsl:with-param name="c" select="parent::node()"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="indent" select="($level - $offset - 1) * 40"/>
                <xsl:variable name="indent2" select="($level - $offset - 1) * 40+60"/>
                <div style="float:left;margin-left:{$indent}px;"><xsl:apply-templates select="ead:did/ead:unitid"/>.
                </div>
                <div style="margin-left:{$indent2}px;word-wrap: break-word;">
                    <xsl:apply-templates select="ead:did/*[not(local-name() = 'unitid')]"/>
                </div>
                <xsl:apply-templates select="*[not(local-name()='did')]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="parent">
        <xsl:param name="c"/>
        <xsl:choose>
            <xsl:when test="$c[@level = 'series' or @level = 'subseries']">
                <xsl:value-of select="substring(local-name($c), 2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="parent">
                    <xsl:with-param name="c" select="$c/parent::*"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:unitid">
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:dsc//*/ead:unittitle">
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="../../@level = 'series'">
                <xsl:call-template name="heading3">
                    <xsl:with-param name="value">
                        <xsl:apply-templates/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="../../@level = 'subseries'">
                <xsl:choose>
                    <xsl:when
                            test="ancestor::ead:c04 | ancestor::ead:c05 | ancestor::ead:c06 | ancestor::ead:c07
                             | ancestor::ead:c08 | ancestor::ead:c09 | ancestor::ead:c09 | ancestor::ead:c10
                              | ancestor::ead:c11 | ancestor::ead:c12">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c02">
                        <xsl:call-template name="heading4">
                            <xsl:with-param name="value">
                                <xsl:apply-templates/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c03">
                        <xsl:call-template name="heading5">
                            <xsl:with-param name="value">
                                <xsl:apply-templates/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="heading3">
        <xsl:param name="value"/>
        <h3>
            <xsl:value-of select="$value"/>
        </h3>
    </xsl:template>
    <xsl:template name="heading4">
        <xsl:param name="value"/>
        <h4>
            <xsl:value-of select="$value"/>
        </h4>
    </xsl:template>
    <xsl:template name="heading5">
        <xsl:param name="value"/>
        <h5>
            <xsl:value-of select="$value"/>
        </h5>
    </xsl:template>

    <xsl:template match="ead:unitdate">
        <xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template match="ead:physdesc/ead:extent">
        <xsl:text> </xsl:text><xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template match="ead:daogrp">
        [ <a href="{ead:daoloc[@label='pdf']/@href}" target="_blank">pdf</a> | <a class="m" href="http://hdl.handle.net/10622/ARCH01225.1?locatt=view:mets">view</a> ] -
    </xsl:template>

</xsl:stylesheet>

