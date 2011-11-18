<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:eci="urn:eci"
                exclude-result-prefixes="eci">

    <xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:param name="notgeschiedenis"/>
    <xsl:param name="action"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//eci:eci"/>
    </xsl:template>

    <xsl:template match="eci:eci">
                   <xsl:apply-templates select="eci:body"/>
    </xsl:template>

    <xsl:template match="eci:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="eci:title"/>

    <xsl:template match="eci:para">
        <div class="eci_para">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="eci:ptxt">
        <div class="eci_ptxt">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="eci:caption">
        <div class="eci_caption">
            <a name="eci_{@id}">
                <xsl:comment>x</xsl:comment>
            </a>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="eci:extref">
        <xsl:choose>
            <xsl:when test="starts-with(@href, 'http://')">

                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>#</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="eci:listitem">
        <li class="eci_li">
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="eci:orderedlist">
        <ol class="eci_list">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="eci:unorderedlist">
        <ul class="eci_list">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="eci:xref">
        <a href="#eci_{@ref}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="eci:table|eci:tr|eci:td">
        <xsl:element name="{local-name(.)}"><xsl:copy-of select="@*"/><xsl:apply-templates/></xsl:element>
    </xsl:template>

</xsl:stylesheet>