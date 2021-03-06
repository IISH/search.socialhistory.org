<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:php="http://php.net/xsl"
                xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xsl mets php xlink">

    <xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:param name="lang"/>
    <xsl:param name="metsId"/>
    <xsl:param name="page"/>
    <xsl:param name="rows"/>
    <xsl:param name="level"/>
    <xsl:param name="visualmets"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//mets:mets"/>
    </xsl:template>

    <xsl:template match="mets:mets">
        <xsl:variable name="count" select="count(mets:structMap[@TYPE='physical']/mets:div/mets:div[@ID])"/>
        <xsl:variable name="pages" select="ceiling($count div $rows)"/>
        <xsl:variable name="url" select="concat('?metsId=', $metsId, '&amp;rows=', $rows,'&amp;level=', $level)"/>

        <div id="mets">
            <div id="metsnav">
                <ul>
                    <li>
                        <xsl:choose>
                            <xsl:when test="$page=1">
                                <xsl:value-of
                                        select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.first')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$url}&amp;page=1">
                                    <xsl:value-of
                                            select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.first')"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="$page=1">
                                <xsl:value-of
                                        select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.previous')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$url}&amp;page={$page - 1}">
                                    <xsl:value-of
                                            select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.previous')"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:value-of
                                select="concat($page, ' ',php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.of'), ' ', $pages)"/>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="$page=$pages">
                                <xsl:value-of
                                        select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.next')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$url}&amp;page={$page + 1}">
                                    <xsl:value-of
                                            select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.next')"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <xsl:choose>
                            <xsl:when test="$page=$pages">
                                <xsl:value-of
                                        select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.last')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$url}&amp;page={$pages}">
                                    <xsl:value-of
                                            select="php:function('ArchiveUtil::translate', $lang, 'ArchiveContentList.last')"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                </ul>
            </div>

            <div style="clear:both"><!-- empty --></div>
            <div id="metsimage">
                <ul>
                    <xsl:variable name="from" select="($page - 1) * $rows"/>
                    <xsl:variable name="to" select="$from + $rows + 1"/>
                    <xsl:variable name="fileSet" select="mets:fileSec/mets:fileGrp[@ID=$level]"/>
                    <xsl:for-each
                            select="mets:structMap[@TYPE='physical']/mets:div/mets:div[@ID][position() &gt; $from and position() &lt; $to]">
                        <xsl:sort data-type="number" select="mets:ORDER"/>
                        <xsl:variable name="alt" select="@LABEL"/>
                        <xsl:for-each select="mets:fptr">
                            <xsl:variable name="FILEID" select="@FILEID"/>
                            <xsl:variable name="file" select="$fileSet/mets:file[@ID=$FILEID]/mets:FLocat"/>
                            <xsl:if test="$file">
                                <li>
                                    <img src="{$file/@xlink:href}" title="{$alt}"/>
                                </li>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>

