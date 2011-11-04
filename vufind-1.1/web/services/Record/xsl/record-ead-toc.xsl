<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                exclude-result-prefixes="ead">

    <xsl:output method="html" encoding="UTF-8"/>

    <xsl:variable name="dutch">
        <xsl:choose>
            <xsl:when test="//ead:langusage = 'Nederlands'">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:if test="ead:archdesc/ead:dsc | ead:archdesc/ead:odd">
            <ul class="fulltoc">
                <xsl:apply-templates select="ead:archdesc/ead:bioghist"/>
                <xsl:apply-templates select="ead:archdesc/ead:scopecontent"/>
                <xsl:apply-templates select="ead:archdesc/ead:descgrp"/>
                <xsl:apply-templates select="ead:archdesc/ead:dsc | ead:archdesc/ead:odd"/>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:bioghist | ead:scopecontent">
        <div class="ead_indent2">
            <xsl:apply-templates select="ead:head"/>
        </div>
    </xsl:template>

    <xsl:template match="ead:descgrp">
        <xsl:if test="//ead:userestrict | //ead:processinfo | //ead:altformavail | //ead:relatedmaterial |
		 //ead:arrangement | //ead:controlaccess[ead:head = 'Tweede archiefvormer'] | //ead:controlaccess[ead:head = 'Secondary creator'] |
		 //ead:otherfindaid | //ead:originalsloc | //ead:relatedmaterial ">
            <div class="ead_indent2">
                <xsl:apply-templates select="ead:head"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:odd">
        <xsl:if test="ead:head">
            <xsl:if test="not(normalize-space(ead:head) = 'Raadpleging' or normalize-space(ead:head) = 'Consultation')">
                <div class="ead_indent2">
                    <xsl:apply-templates select="ead:head"/>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:dsc">
        <xsl:if test="@audience = 'external'">
            <div class="ead_indent2">
                <xsl:apply-templates select="ead:head"/>
            </div>
            <xsl:apply-templates select="ead:c01"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:head">
        <xsl:apply-templates mode="simple"/>
    </xsl:template>

    <!-- list elements -->
    <xsl:template match="*[@level='series']">
        <xsl:apply-templates select="ead:did/ead:unittitle"/>
        <xsl:if test="*[@level = 'subseries']/ead:did/ead:unittitle">
            <xsl:apply-templates select="*[@level = 'subseries']"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[@level = 'subseries']">
        <xsl:if test="ead:did/ead:unittitle">
            <xsl:apply-templates select="ead:did/ead:unittitle"/>
            <xsl:if test="*[@level = 'subseries']/ead:did/ead:unittitle">
                <xsl:apply-templates select="*[@level = 'subseries']"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="simple">
        <xsl:apply-templates mode="simple"/>
    </xsl:template>

    <xsl:template match="ead:did">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:did/ead:unittitle">
        <xsl:apply-templates mode="simple"/>
    </xsl:template>

    <xsl:template match="ead:unittitle">
        <!-- check the hierarchical level -->
        <xsl:variable name="level">
            <xsl:value-of select="count(ancestor::ead:c01 | ancestor::ead:c02 | ancestor::ead:c03 | ancestor::ead:c04 |
			ancestor::ead:c05 | ancestor::ead:c06 | ancestor::ead:c07 | ancestor::ead:c08 | ancestor::ead:c09 |
			 ancestor::ead:c10 | ancestor::ead:c11 | ancestor::ead:c12)"/>
        </xsl:variable>
        <div>
            <xsl:call-template name="insertSpaces">
                <xsl:with-param name="spaces2insert" select="$level * 2 + 2"/>
            </xsl:call-template>
            <xsl:apply-templates mode="simple"/>
        </div>
    </xsl:template>

    <!-- named templates -->
    <xsl:template name="insertSpaces">
        <xsl:param name="spaces2insert"/>
        <xsl:attribute name="class">ead_indent<xsl:value-of select="$spaces2insert"/>
        </xsl:attribute>

    </xsl:template>

</xsl:stylesheet>