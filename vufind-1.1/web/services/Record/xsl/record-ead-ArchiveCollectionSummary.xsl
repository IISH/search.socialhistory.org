<?xml version="1.0" encoding="UTF-8"?>

<!-- For the rendering see SEARCH-163
    We will return a model in json. The PHP will serialize that into an array to the view.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
                xmlns:php="http://php.net/xsl"
                exclude-result-prefixes="xsl ead xsi php xlink">

    <xsl:import href="record-ead-Archive.xsl"/>
    <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="action"/>
    <xsl:param name="baseUrl"/>
    <xsl:param name="lang"/>
    <xsl:param name="title"/>

    <xsl:variable name="digital_items" select="count(//ead:daogrp[starts-with(ead:daoloc/@xlink:href, 'http://hdl.handle.net/10622/')])"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:call-template name="navigation"/>
        <xsl:if test="$digital_items>0">
            <div id="teaser">
                <img src=""/>
                <p>
                    <xsl:call-template name="language">
                        <xsl:with-param name="key">ArchiveCollectionSummary.image</xsl:with-param>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
        <div id="arch">
            <table>
                <xsl:call-template name="creator"/>
                <xsl:call-template name="secondcreator"/>
                <xsl:call-template name="abstract"/>
                <xsl:call-template name="period"/>
                <xsl:call-template name="extent"/>
                <xsl:call-template name="access"/>
                <xsl:call-template name="digitalform"/>
                <xsl:call-template name="langmaterial"/>
                <xsl:call-template name="collectionid"/>
                <xsl:call-template name="repository"/>
                <xsl:call-template name="pid"/>
            </table>
        </div>

        <xsl:if test="$digital_items>0">
            <script type="text/javascript">
                (function() {
                var urls=[
                <xsl:for-each select="//ead:daogrp/ead:daoloc[@xlink:label='thumbnail'][1]/@xlink:href">
                    '<xsl:value-of select="."/>'
                    <xsl:if test="not(position()=last())">,</xsl:if>
                </xsl:for-each>
                ];
                function swap() {
                    $('#teaser img').attr('src', urls[Math.round(Math.random() * urls.length)]);
                }
                swap();
                $('#teaser img').click(function(){
                    var src = this.src;
                    document.location.href = src.substring(0, src.length-6) + 'catalog';
                });
                setInterval( swap, 5000 ) ;
                })();
            </script>
        </xsl:if>

    </xsl:template>

    <xsl:template name="creator">
        <xsl:variable name="value">
            <xsl:for-each select="ead:archdesc/ead:did/ead:origination[@label='Creator' or @label='creator']/*">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="string-length($value) > 0">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.creator.first'"/>
                <xsl:with-param name="value">
                    <ul>
                        <xsl:copy-of select="$value"/>
                    </ul>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="secondcreator">
        <xsl:variable name="value">
            <xsl:for-each select="ead:archdesc/ead:did/ead:origination[not(@label='Creator' or @label='creator')]/*">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="string-length($value) > 0">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.creator.second'"/>
                <xsl:with-param name="value">
                    <ul>
                        <xsl:copy-of select="$value"/>
                    </ul>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="abstract">
        <xsl:variable name="more">
            <xsl:value-of
                    select="php:function('ArchiveUtil::truncate' , string(ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:scopecontent/ead:p[1]), 300)"/>
            <a href="{concat($baseUrl, '/', 'ArchiveContentAndStructure')}">
                <br/>
                <xsl:call-template name="language">
                    <xsl:with-param name="key" select="'ArchiveCollectionSummary.abstract.more'"/>
                </xsl:call-template>
            </a>
        </xsl:variable>
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveCollectionSummary.abstract'"/>
            <xsl:with-param name="value" select="$more"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="period">
        <xsl:for-each select="ead:archdesc/ead:did/ead:unitdate">
            <xsl:variable name="key">
                <xsl:choose>
                    <xsl:when test="position()=1">
                        <xsl:value-of
                                select="'ArchiveCollectionSummary.period'"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="$key"/>
                <xsl:with-param name="value">
                    <xsl:value-of select="text()"/>
                    (
                    <xsl:call-template name="language">
                        <xsl:with-param name="key"
                                        select="concat('ArchiveCollectionSummary.period', '.', @type)"/>
                    </xsl:call-template>
                    )
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="extent">
        <xsl:variable name="value">
            <xsl:for-each select="ead:archdesc/ead:did/ead:physdesc/ead:extent">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="string-length($value) > 0">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.extent'"/>
                <xsl:with-param name="value">
                    <ul>
                        <xsl:copy-of select="$value"/>
                    </ul>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="access">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveCollectionSummary.access'"/>
            <xsl:with-param name="value">
                <a href="{concat($baseUrl, '/', 'ArchiveAccessAndUse')}">
                    <xsl:value-of
                            select="ead:archdesc/ead:descgrp[@type='access_and_use']/ead:accessrestrict/ead:p[1]/text()"/>
                </a>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="digitalform">
        <xsl:if test="$digital_items>0">
            <xsl:variable name="value">
                <xsl:value-of select="$digital_items"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="language">
                    <xsl:with-param name="key" select="'ArchiveCollectionSummary.digitalform.items'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.digitalform'"/>
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="langmaterial">
        <xsl:variable name="value">
            <xsl:for-each select="ead:archdesc/ead:did/ead:langmaterial/ead:language">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="string-length($value) > 0">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.langmaterial'"/>
                <xsl:with-param name="value">
                    <ul>
                        <xsl:copy-of select="$value"/>
                    </ul>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="collectionid">
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveCollectionSummary.collectionID'"/>
            <xsl:with-param name="value">
                <xsl:value-of select="ead:archdesc/ead:did/ead:unitid"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="repository">
        <xsl:variable name="repository" select="ead:archdesc/ead:did/ead:repository/ead:corpname"/>
        <xsl:if test="$repository">
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="'ArchiveCollectionSummary.repository'"/>
                <xsl:with-param name="value" select="$repository/text()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="pid">
        <xsl:variable name="handle" select="normalize-space( ead:eadheader/ead:eadid)"/>
        <xsl:call-template name="row">
            <xsl:with-param name="key" select="'ArchiveCollectionSummary.pid'"/>
            <xsl:with-param name="value">
                <a href="{$handle}" target="_blank">
                    <xsl:value-of select="$handle"/>
                </a>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>

