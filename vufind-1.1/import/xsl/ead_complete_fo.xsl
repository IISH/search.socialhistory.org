<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="exsl fo ead">

    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    <!--  YP: param block: Deze parameters moeten meegegeven zijn met de transformatie. Zoniet dan worden de hier vermelde defaults gebruikt -->
    <xsl:param name="modificationDateNL">1971-01-01</xsl:param>
    <!-- YP: Het beginpunt van veel IT tijdrekening; A star (Unix) is born -->
    <xsl:param name="modificationDateXL">1989-11-11</xsl:param>
    <!-- YP: The Wall is coming down -->
    <xsl:param name="sysYear">1971</xsl:param>
    <xsl:param name="path"/>

    <!-- Teksten die door de stylesheet worden geplaatst -->
    <xsl:variable name="txtLCNNumberNL">Archival identifier</xsl:variable>
    <xsl:variable name="txtLCNNumber">Archiefnummer</xsl:variable>
    <xsl:variable name="txtIdNL">Archiefnummer</xsl:variable>
    <xsl:variable name="txtId">Collection ID</xsl:variable>
    <xsl:variable name="txtCreatorNL">Archiefvormer</xsl:variable>
    <xsl:variable name="txtCreator">Creator</xsl:variable>
    <xsl:variable name="txtCreator2NL">Tweede archiefvormer</xsl:variable>
    <xsl:variable name="txtCreator2">Other Creator(s)</xsl:variable>
    <xsl:variable name="txtPeriodNL">Periode</xsl:variable>
    <xsl:variable name="txtPeriod">Period</xsl:variable>
    <xsl:variable name="txtPeriodBulkNL">Periode (bulk)</xsl:variable>
    <xsl:variable name="txtPeriodBulk">Period (bulk)</xsl:variable>
    <xsl:variable name="txtSizeNL">Omvang</xsl:variable>
    <xsl:variable name="txtSize">Extent</xsl:variable>
    <xsl:variable name="txtLangListNL">Taal lijst</xsl:variable>
    <xsl:variable name="txtLangMaterialNL">Taal materiaal</xsl:variable>
    <xsl:variable name="txtLangList">Language list</xsl:variable>
    <xsl:variable name="txtLangMaterial">Language of Material</xsl:variable>
    <xsl:variable name="txtLastModified">Last modified</xsl:variable>
    <xsl:variable name="txtLastModifiedNL">Laatst gewijzigd</xsl:variable>
    <xsl:variable name="txtTitleToc">Table of contents</xsl:variable>
    <xsl:variable name="txtTitleTocNL">Inhoudsopgave</xsl:variable>
    <xsl:variable name="txtAbstract">Abstract</xsl:variable>
    <xsl:variable name="txtAbstractNL">Samenvatting</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <!-- Einde teksten die door de stylesheet worden geplaatst -->
    <!-- variables -->

    <xsl:variable name="widthlist">
        <colwidth colno="1">3cm</colwidth>
        <colwidth colno="2">6cm</colwidth>
        <colwidth colno="3">3cm</colwidth>
        <colwidth colno="4">3cm</colwidth>
    </xsl:variable>

    <xsl:variable name="lang">
        <xsl:choose>
            <xsl:when test="//ead:langusage/ead:language[1]/@langcode='dut'">dut</xsl:when>
            <xsl:otherwise>eng</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="copyright">
        <xsl:text>© </xsl:text>
        <xsl:choose>
            <xsl:when test="$lang = 'dut'">
                <xsl:text>IISG </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>IISH </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>Amsterdam </xsl:text>
        <xsl:value-of select="$sysYear"/>
    </xsl:variable>

    <xsl:template match="text()"><!-- replace tabs and returns with spaces -->
        <xsl:variable name="st">&#xA;</xsl:variable>
        <xsl:value-of select="translate(.,concat(' ', $st),'  ')"/>
    </xsl:template>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="simpleA4" page-height="29.7cm" page-width="21cm" margin-top="5mm"
                                       margin-bottom="0cm" margin-left="2cm" margin-right="2cm">
                    <fo:region-body margin-bottom="23mm" margin-top="15mm"/>
                    <fo:region-before extent="12mm"/>
                    <fo:region-after extent="12mm"/>
                </fo:simple-page-master>
                <fo:simple-page-master master-name="TitlePage" page-height="29.7cm" page-width="21cm" margin-top="7cm"
                                       margin-bottom="1cm" margin-left="2cm" margin-right="2cm">
                    <fo:region-body region-name="title"/>
                    <fo:region-after extent="1cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <xsl:apply-templates select="//ead:ead"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="ead:ead">
        <fo:page-sequence master-reference="TitlePage">
            <fo:static-content flow-name="xsl-region-after">
                <fo:block font-family="Arial" font-size="10pt" font-style="italic" margin-left="10cm">
                    <xsl:value-of select="$copyright"/>
                </fo:block>
            </fo:static-content>
            <fo:flow flow-name="title">
                <fo:block text-align="center" space-after.optimum="1cm">
                    <fo:block text-align="center" space-after.optimum="1.5cm">
                        <xsl:variable name="corpname">
                            <xsl:value-of select="//ead:archdesc/ead:did/ead:repository/ead:corpname"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($corpname, 'Geschiedenis') or contains($corpname, 'History')">
                                <fo:external-graphic src="{$path}/logo_iisg-{$lang}.jpg"
                                                     content-height="3cm" scaling="uniform" height="3cm"/>
                            </xsl:when>
                            <xsl:when test="contains($corpname, 'IHLIA')">
                                <fo:external-graphic src="{$path}/logo_ihlia.gif"
                                                     content-height="3cm" scaling="uniform" height="3cm"/>
                            </xsl:when>
                            <xsl:when test="contains($corpname, 'NEHA')">
                                <fo:external-graphic src="{$path}/logo_neha.gif"
                                                     content-height="3cm" scaling="uniform" height="3cm"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:external-graphic src="{$path}/logo_pm.jpg"
                                                     content-height="2cm" scaling="uniform" height="2cm"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                    <fo:block font-family="'Arial'" font-size="20pt" font-weight="bold" text-align="center">
                        <fo:block>
                            <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unittitle"/>
                        </fo:block>
                        <fo:block>
                            <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unitdate"/>
                        </fo:block>
                    </fo:block>
                </fo:block>
                <fo:block-container position="absolute" left="10cm" top="17cm" height="2cm" width="8cm"
                                    font-size="10pt">
                    <fo:block>
                        <fo:block>
                            <xsl:apply-templates select="//ead:repository/ead:corpname"/>
                        </fo:block>
                        <fo:block space-after.optimum="10mm">
                            <xsl:apply-templates select="//ead:repository/ead:address"/>
                        </fo:block>
                    </fo:block>
                </fo:block-container>
                <fo:block-container position="absolute" left="10cm" top="19cm" font-size="10pt" width="8cm"
                                    height="17mm">
                    <fo:block>
                        <!--
                                                <xsl:choose>
                                                    <xsl:when test="$lang = 'dut'">
                                                        <xsl:value-of select="$txtLastModifiedNL"/>:
                                                        <xsl:value-of select="$modificationDateNL"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$txtLastModified"/>:
                                                        <xsl:value-of select="$modificationDateXL"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                        -->
                    </fo:block>
                    <fo:block space-before.optimum="4mm">
                        <fo:basic-link external-destination="{ead:eadheader/ead:eadid/text()}">
                            <xsl:value-of
                                    select="ead:eadheader/ead:eadid/@identifier"/>
                        </fo:basic-link>
                    </fo:block>
                </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
        <!-- TOC -->
        <fo:page-sequence master-reference="simpleA4">
            <fo:static-content flow-name="xsl-region-before">
                <fo:block font-family="Arial" font-size="10pt" text-align="right" color="grey">
                    <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unittitle"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unitdate"/>
                </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after">
                <fo:block/>
                <fo:block font-family="Arial" font-size="10pt" text-align-last="justify">
                    <fo:inline color="grey" font-style="italic">
                        <xsl:apply-templates select="//ead:repository/ead:corpname"/>
                    </fo:inline>
                    <fo:leader leader-pattern="space"/>
                    <fo:page-number/>
                </fo:block>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block font-family="'Arial'" font-size="11pt">
                    <xsl:call-template name="createTOC"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>

        <!-- actual content -->
        <fo:page-sequence master-reference="simpleA4">
            <fo:static-content flow-name="xsl-region-before">
                <fo:block font-family="Arial" font-size="10pt" text-align="right" color="grey">
                    <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unittitle"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="//ead:archdesc/ead:did/ead:unitdate"/>
                </fo:block>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after">
                <fo:block/>
                <fo:block font-family="Arial" font-size="10pt" text-align-last="justify">
                    <fo:inline color="grey" font-style="italic">
                        <xsl:apply-templates select="//ead:repository/ead:corpname"/>
                    </fo:inline>
                    <fo:leader leader-pattern="space"/>
                    <fo:page-number/>
                </fo:block>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block font-family="'Arial'" font-size="11pt" id="{generate-id(ead:archdesc/ead:did/ead:unittitle)}">
                    <xsl:call-template name="heading2">
                        <xsl:with-param name="value">
                            <xsl:apply-templates select="ead:archdesc/ead:did/ead:unittitle"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <fo:block space-after.optimum="6pt">
                        <xsl:choose>
                            <xsl:when test="$lang = 'dut'">
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtIdNL"/>
                                    </fo:inline>
                                    &#xA0;<xsl:value-of select="ead:archdesc/ead:did/ead:unitid"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtCreatorNL"/>
                                    </fo:inline>
                                    &#xA0;<xsl:value-of
                                        select="ead:archdesc/ead:did/ead:origination[@label='Creator']"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:origination[@label='Other Creator']">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtCreator2NL"/>
                                        </fo:inline>
                                        &#xA0;<xsl:value-of
                                            select="ead:archdesc/ead:did/ead:origination[@label='Other Creator']"/>
                                    </xsl:if>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtPeriodNL"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:unitdate"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:unitdate[@type='bulk']">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtPeriodBulkNL"/>
                                        </fo:inline>
                                        &#xA0;
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:unitdate[@type='bulk']"/>
                                    </xsl:if>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtSizeNL"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:physdesc"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtLangListNL"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates
                                            select="ead:eadheader/ead:profiledesc/ead:langusage/ead:language"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtLangMaterialNL"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:langmaterial"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:abstract">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtAbstractNL"/>
                                        </fo:inline>
                                        &#xA0;
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:abstract"/>
                                    </xsl:if>
                                </fo:block>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtId"/>
                                    </fo:inline>
                                    &#xA0;<xsl:value-of select="ead:archdesc/ead:did/ead:unitid"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtCreator"/>
                                    </fo:inline>
                                    &#xA0;<xsl:value-of
                                        select="ead:archdesc/ead:did/ead:origination[@label='Creator']"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:origination[@label='Other Creator']">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtCreator2"/>
                                        </fo:inline>
                                        &#xA0;<xsl:value-of
                                            select="ead:archdesc/ead:did/ead:origination[@label='Other Creator']"/>
                                    </xsl:if>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtPeriod"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:unitdate"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:unitdate[@type='bulk']">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtPeriodBulk"/>
                                        </fo:inline>
                                        &#xA0;
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:unitdate[@type='bulk']"/>
                                    </xsl:if>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtSize"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:physdesc"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtLangList"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates
                                            select="ead:eadheader/ead:profiledesc/ead:langusage/ead:language"/>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$txtLangMaterial"/>
                                    </fo:inline>
                                    &#xA0;
                                    <xsl:apply-templates select="ead:archdesc/ead:did/ead:langmaterial"/>
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="ead:archdesc/ead:did/ead:abstract">
                                        <fo:inline font-weight="bold">
                                            <xsl:value-of select="$txtAbstract"/>
                                        </fo:inline>
                                        &#xA0;
                                        <xsl:apply-templates select="ead:archdesc/ead:did/ead:abstract"/>
                                    </xsl:if>
                                </fo:block>

                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>

                    <!-- <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:head"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:accessrestrict"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:userestrict"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:acqinfo"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:processinfo"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:bioghist"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:scopecontent"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:arrangement"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:controlaccess"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:otherfindaid"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:altformavail"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:originalsloc"/>
                     <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:relatedmaterial"/>-->

                    <xsl:apply-templates select="ead:archdesc/ead:descgrp"/>

                    <xsl:apply-templates
                            select="ead:archdesc/ead:dsc | ead:archdesc/ead:odd[following::ead:dsc] | ead:archdesc/ead:odd[preceding::ead:dsc]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>


    <!--  Iisg/archdesc/* templates -->

    <xsl:template
            match="ead:bioghist | ead:scopecontent | ead:accessrestrict | ead:userestrict | ead:acqinfo | ead:processinfo | ead:arrangement | ead:controlaccess | ead:altformavail | ead:originalsloc | ead:relatedmaterial | ead:otherfindaid | ead:custodhist | ead:prefercite | ead:separatedmaterial">
        <fo:block id="{generate-id()}">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="name()"/>
            </fo:marker>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:dsc">
        <fo:block id="{generate-id()}">
            <fo:marker marker-class-name="anchor">dsc</fo:marker>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:odd">
        <xsl:if test="not(normalize-space(ead:head) = 'Raadpleging' or normalize-space(ead:head) = 'Consultation')">
            <fo:block id="{generate-id()}">
                <fo:marker marker-class-name="anchor">
                    <xsl:value-of select="generate-id()"/>
                </fo:marker>
                <xsl:apply-templates/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template
            match="ead:bioghist/ead:head | ead:scopecontent/ead:head | ead:accessrestrict/ead:head | ead:userestrict/ead:head | ead:acqinfo/ead:head | ead:processinfo/ead:head | ead:arrangement/ead:head | ead:controlaccess/ead:head | ead:altformavail/ead:head | ead:originalsloc/ead:head | ead:relatedmaterial/ead:head | ead:otherfindaid/ead:head | ead:custodhist/ead:head | ead:prefercite/ead:head | ead:separatedmaterial/ead:head">
        <xsl:call-template name="heading4">
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:descgrp/ead:head">
        <fo:block id="{generate-id()}">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:call-template name="heading2">
                <xsl:with-param name="value">
                    <xsl:apply-templates/>
                </xsl:with-param>
            </xsl:call-template>

        </fo:block>
    </xsl:template>

    <xsl:template match="ead:odd/ead:head[following-sibling::ead:table]">
        <xsl:call-template name="heading2">
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:odd/ead:head">
        <xsl:call-template name="heading3">
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Iisg/archdesc/dsc  templates -->

    <xsl:template match="ead:dsc/ead:head">
        <!-- KW 20060921 Hier werd heading3 aangeroepen -->
        <xsl:call-template name="heading2">
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:dsc/ead:p/text()">
        <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:template>
    <xsl:template match="head">
        <xsl:call-template name="heading6">
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
            match="ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 | ead:c10 | ead:c11 | ead:c12">
        <xsl:choose>
            <xsl:when test="@level = 'series' or @level = 'subseries'">
                <fo:block id="{generate-id()}" space-before="12pt">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:list-block space-after.optimum="2mm" provisional-distance-between-starts="27mm"
                               provisional-label-separation="5mm" id="{generate-id()}">
                    <fo:list-item space-after="-5pt">
                        <fo:list-item-label end-indent="label-end()" text-align="right">
                            <fo:block>
                                <xsl:apply-templates select="ead:did/ead:unitid"/>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                            <fo:block>
                                <xsl:apply-templates select="ead:did/*[not(name() = 'unitid')]"/>
                            </fo:block>
                            <xsl:apply-templates select="*[not(name()='did')]"/>
                        </fo:list-item-body>
                    </fo:list-item>
                </fo:list-block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:list">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:item">
        <fo:block>
            <xsl:value-of select="."/>
        </fo:block>
    </xsl:template>


    <xsl:template match="ead:unitid">
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <fo:inline>
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <fo:inline>
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:dsc//*/ead:unittitle">
        <xsl:if test="position() &gt; 1">
            <fo:block/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <fo:inline>
                    <xsl:apply-templates/>
                </fo:inline>
                <xsl:if test="following::*[1][@level = 'series' or @level = 'subseries']">
                    <fo:leader/>
                </xsl:if>
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
                            test="ancestor::ead:c04 | ancestor::ead:c05 | ancestor::ead:c06 | ancestor::ead:c07 | ancestor::ead:c08 | ancestor::ead:c09 | ancestor::ead:c10 | ancestor::ead:c11 | ancestor::ead:c12">
                        <fo:block margin-bottom="12pt">
                            <fo:marker marker-class-name="anchor">
                                <xsl:value-of select="generate-id()"/>
                            </fo:marker>
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c03">
                        <fo:block margin-bottom="12pt">
                            <fo:marker marker-class-name="anchor">
                                <xsl:value-of select="generate-id()"/>
                            </fo:marker>
                            <xsl:call-template name="heading5">
                                <xsl:with-param name="value">
                                    <xsl:apply-templates/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c02">
                        <fo:block>
                            <fo:marker marker-class-name="anchor">
                                <xsl:value-of select="generate-id()"/>
                            </fo:marker>
                            <xsl:call-template name="heading4">
                                <xsl:with-param name="value">
                                    <xsl:apply-templates/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <fo:inline>
                    <xsl:apply-templates/>
                </fo:inline>
                <xsl:if test="following::*[1][@level = 'series' or @level = 'subseries']">
                    <fo:leader/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ead:physdesc">
        <fo:inline>
            <xsl:text>&#xA0;</xsl:text>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>


    <xsl:template match="ead:addressline">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:p">
        <fo:block space-after.optimum="6pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:note/ead:p">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:note">
        <fo:block space-after.optimum="2mm">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:title">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="ead:lb">
        <fo:block/>
    </xsl:template>
    <xsl:template match="ead:titleproper/ead:date">
        <fo:block font-size="14pt" space-before.optimum="5mm" font-style="italic">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:geogname">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:persname">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:corpname">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:subject">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:controlaccess/ead:genreform">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!--<xsl:template match="ead:origination[@label='Other Creator']/ead:persname">
        <xsl:apply-templates /><xsl:text>; </xsl:text>
    </xsl:template> -->

    <xsl:template name="heading1">
        <xsl:param name="value"/>
        <fo:block font-size="18pt" font-weight="bold" space-before.optimum="10mm" space-after="12pt">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="heading2">
        <xsl:param name="value"/>
        <fo:block font-size="15pt" font-weight="bold" space-before.optimum="10mm" space-after="12pt">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="heading3">
        <xsl:param name="value"/>
        <fo:block font-size="14pt" font-weight="bold" space-before.optimum="10mm" space-after="12pt">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="heading4">
        <xsl:param name="value"/>
        <fo:block font-size="13pt" font-weight="bold" space-before.optimum="10mm">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="heading5">
        <xsl:param name="value"/>
        <fo:block font-size="12pt" font-weight="bold" space-before.optimum="10mm">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="heading6">
        <xsl:param name="value"/>
        <fo:block font-size="11pt" text-decoration="underline" space-before.optimum="10mm">
            <fo:marker marker-class-name="anchor">
                <xsl:value-of select="generate-id()"/>
            </fo:marker>
            <xsl:value-of select="$value"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="createTOC">
        <xsl:call-template name="heading1">
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test="$lang = 'dut' ">
                        <xsl:value-of select="$txtTitleTocNL"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$txtTitleToc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="ead:archdesc/ead:did/ead:unittitle" mode="toc"/>
        <xsl:apply-templates select="ead:archdesc/ead:bioghist" mode="toc"/>
        <xsl:apply-templates select="ead:archdesc/ead:scopecontent" mode="toc"/>

        <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:head" mode="toc"/>

        <xsl:apply-templates select="ead:archdesc/ead:dsc | ead:archdesc/ead:odd" mode="toc"/>
    </xsl:template>


    <xsl:template match="ead:bioghist | ead:scopecontent" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates select="ead:head" mode="toc"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:descgrp/ead:head" mode="toc">
        <xsl:if test="//ead:userestrict | //ead:processinfo | //ead:altformavail | //ead:relatedmaterial | //ead:arrangement | //ead:controlaccess[normalize-space(ead:head) = 'Tweede archiefvormer'] | //ead:controlaccess[normalize-space(ead:head) = 'Secondary creator'] | //ead:otherfindaid | //ead:originalsloc | //ead:relatedmaterial ">
            <xsl:call-template name="hyper-toc-entry">
                <xsl:with-param name="entry-titel">
                    <xsl:apply-templates mode="tocsimple"/>
                </xsl:with-param>
                <xsl:with-param name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="odd" mode="toc">
        <xsl:if test="ead:head">
            <xsl:if test="not(normalize-space(ead:head) = 'Raadpleging' or normalize-space(ead:head) = 'Consultation')">
                <!-- li -->
                <xsl:call-template name="hyper-toc-entry">
                    <xsl:with-param name="entry-titel">
                        <xsl:apply-templates select="ead:head" mode="toc"/>
                    </xsl:with-param>
                    <xsl:with-param name="id">
                        <xsl:value-of select="generate-id()"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:dsc" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates select="ead:head" mode="toc"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:with-param>
        </xsl:call-template>
        <fo:block>
            <xsl:apply-templates select="ead:c01" mode="toc"/>
        </fo:block>
    </xsl:template>


    <xsl:template match="ead:head" mode="toc">
        <xsl:apply-templates mode="tocsimple"/>
    </xsl:template>


    <xsl:template name="hyper-toc-entry">
        <xsl:param name="entry-titel"/>
        <xsl:param name="id"/>
        <fo:block text-align-last="justify">
            <fo:basic-link internal-destination="{$id}">
                <fo:inline>
                    <xsl:value-of select="$entry-titel"/>
                </fo:inline>
            </fo:basic-link>
            <fo:leader leader-pattern="dots"/>
            <fo:basic-link internal-destination="{$id}">
                <fo:inline>
                    <fo:page-number-citation ref-id="{$id}"/>
                </fo:inline>
            </fo:basic-link>
        </fo:block>
    </xsl:template>


    <!-- list elements -->
    <xsl:template match="ead:c01[@level='series']" mode="toc">
        <fo:block margin-left="6mm">
            <xsl:apply-templates select="ead:did/ead:unittitle" mode="toc"/>
            <xsl:if test="ead:c02[@level = 'subseries']/ead:did/ead:unittitle">
                <xsl:apply-templates select="ead:c02[@level = 'subseries']" mode="toc"/>
            </xsl:if>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:c02[@level = 'subseries']" mode="toc">
        <xsl:if test="ead:did/ead:unittitle">
            <fo:block margin-left="9mm">
                <xsl:apply-templates select="ead:did/ead:unittitle" mode="toc"/>
                <xsl:if test="ead:c03[@level = 'subseries']/ead:did/ead:unittitle">
                    <!-- start list -->
                    <fo:block>
                        <xsl:apply-templates select="ead:c03[@level = 'subseries']" mode="toc"/>
                    </fo:block>
                </xsl:if>
            </fo:block>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ead:c03[@level = 'subseries']" mode="toc">
        <fo:block margin-left="12mm">
            <xsl:if test="ead:did/ead:unittitle">
                <xsl:apply-templates select="ead:did/ead:unittitle" mode="toc"/>
            </xsl:if>
            <xsl:apply-templates
                    select="*[(starts-with(name(),'c0') or starts-with(name(),'c1')) and @level = 'subseries']"
                    mode="toc"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c04" mode="toc">
        <fo:block margin-left="16mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c05" mode="toc">
        <fo:block margin-left="20mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c06" mode="toc">
        <fo:block margin-left="24mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c07" mode="toc">
        <fo:block margin-left="28mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c08" mode="toc">
        <fo:block margin-left="32mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c09" mode="toc">
        <fo:block margin-left="36mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c10" mode="toc">
        <fo:block margin-left="40mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c11" mode="toc">
        <fo:block margin-left="44mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="ead:c12" mode="toc">
        <fo:block margin-left="48mm">
            <xsl:call-template name="c0X"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="c0X">
        <xsl:if test="ead:did/ead:unittitle">
            <xsl:apply-templates select="ead:did/ead:unittitle" mode="toc"/>
        </xsl:if>
        <xsl:apply-templates select="*[(starts-with(name(),'c0') or starts-with(name(),'c1')) and @level = 'subseries']"
                             mode="toc"/>
    </xsl:template>

    <xsl:template match="*" mode="toc">
    </xsl:template>
    <xsl:template match="*" mode="tocsimple">
        <xsl:apply-templates mode="tocsimple"/>
    </xsl:template>
    <xsl:template match="ead:did" mode="toc">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:did/ead:unittitle" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates mode="tocsimple"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:unittitle" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates mode="tocsimple"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id(../..)"/>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="ead:c01/ead:did/ead:unittitle" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates mode="tocsimple"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id(../..)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:c02/ead:did/ead:unittitle" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates mode="tocsimple"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id(../..)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:c03/ead:did/ead:unittitle" mode="toc">
        <xsl:call-template name="hyper-toc-entry">
            <xsl:with-param name="entry-titel">
                <xsl:apply-templates mode="tocsimple"/>
            </xsl:with-param>
            <xsl:with-param name="id">
                <xsl:value-of select="generate-id(../..)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ead:table">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:tgroup">
        <fo:table table-layout="fixed">
            <xsl:call-template name="insertcolumns">
                <xsl:with-param name="number" select="@cols"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:table>
    </xsl:template>

    <xsl:template match="ead:tbody">
        <fo:table-body>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="ead:row">
        <fo:table-row>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="ead:entry">
        <fo:table-cell>
            <fo:block>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template name="insertcolumns">
        <xsl:param name="number"/>
        <xsl:param name="colno">1</xsl:param>
        <xsl:variable name="colwidth" select="exsl:node-set($widthlist)/colwidth[@colno = $colno]"/>
        <xsl:choose>
            <xsl:when test="$number &gt; 0">
                <fo:table-column column-width="{$colwidth}">
                    <xsl:attribute name="column-number">
                        <xsl:value-of select="$colno"/>
                    </xsl:attribute>
                </fo:table-column>
                <xsl:variable name="newNumber">
                    <xsl:value-of select="$number - 1"/>
                </xsl:variable>
                <xsl:call-template name="insertcolumns">
                    <xsl:with-param name="number" select="$newNumber"/>
                    <xsl:with-param name="colno" select="$colno+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>