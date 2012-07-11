<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                exclude-result-prefixes="ead">

    <xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:param name="notgeschiedenis"/>
    <xsl:param name="action"/>
    <xsl:param name="access"/>
    <xsl:param name="physical"/>
    <xsl:param name="large_archive"/>
    <xsl:param name="no_inventory"/>
    <xsl:param name="metsBaseUrl"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:choose>
            <xsl:when test="$action='Description'">
                <xsl:call-template name="description"/>
            </xsl:when>
            <xsl:when test="$action='Holdings'">
                <xsl:call-template name="introduction"/>
                <xsl:choose>
                    <xsl:when test="ead:archdesc/ead:dsc[@audience='external']">
                        <xsl:apply-templates select="ead:archdesc/ead:dsc[@audience='external']"/>
                    </xsl:when>
                    <xsl:when
                            test="not(ead:archdesc/ead:dsc) and ($access='Vrij' or $access='Not restricted') and $physical > 5">
                        <!-- see https://diwoto.iisg.nl/projects/search/ticket/31 -->
                        <p>
                            <xsl:value-of select="$large_archive"/>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:value-of select="$no_inventory"/>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="description">
        <xsl:if test="ead:archdesc/ead:descgrp/ead:userestrict">
            <tr>
                <th>
                    <xsl:value-of select="ead:archdesc/ead:descgrp/ead:userestrict/ead:head/text()"/>
                </th>
                <td>
                    <xsl:copy-of select="ead:archdesc/ead:descgrp/ead:userestrict/ead:p/text()"/>
                </td>
            </tr>
        </xsl:if>
        <xsl:apply-templates select="ead:archdesc/ead:bioghist"/>
        <xsl:apply-templates select="ead:archdesc/ead:scopecontent"/>
        <xsl:apply-templates select="ead:archdesc/ead:arrangement"/>
        <xsl:apply-templates select="ead:archdesc/ead:descgrp/ead:processinfo"/>
        <xsl:apply-templates select="ead:archdesc/ead:controlaccess[2]"/>
        <xsl:apply-templates select="ead:archdesc/ead:altformavail"/>
        <xsl:apply-templates select="ead:archdesc/ead:originalsloc"/>
        <xsl:apply-templates select="ead:archdesc/ead:relatedmaterial"/>
        <xsl:apply-templates select="ead:archdesc/ead:otherfindaid"/>

    </xsl:template>

    <xsl:template name="introduction">
        <!-- (tot aan </descgrp> of </controlaccess> of tot eerste <odd>. -->
        <xsl:apply-templates select="ead:archdesc/ead:odd"/>
    </xsl:template>


    <xsl:template match="ead:accessrestrict/ead:p[1]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:archdesc/ead:did/ead:repository/ead:corpname">
        <xsl:if test="not( contains(., 'Geschiedenis')) and not( contains(., 'History'))">
            <strong>
                <xsl:value-of select="$notgeschiedenis"/>
            </strong>
            &#xA0;<xsl:value-of select="."/>
            <br/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:accessrestrict/ead:p[1]/ead:address"/>

    <xsl:template match="ead:bioghist | ead:scopecontent | ead:userestrict | ead:arrangement | ead:processinfo |
	 ead:controlaccess | ead:altformavail | ead:originalsloc | ead:relatedmaterial | ead:otherfindaid">


        <tr>
            <th>
                <xsl:apply-templates select="ead:head"/>
                <a>
                    <xsl:attribute name="name">
                        <xsl:value-of select="local-name()"/>
                    </xsl:attribute>
                </a>
            </th>
            <td>
                <xsl:apply-templates select="*[not(local-name() = 'head')]"/>
            </td>
        </tr>

    </xsl:template>

    <xsl:template match="ead:dsc/ead:p/text()">
        <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:template>

    <xsl:template match="ead:head">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:dsc">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:dsc/ead:head">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:odd">
        <xsl:if test="not(normalize-space(ead:head) = 'Raadpleging' or normalize-space(ead:head) = 'Consultation')">
            <tr>
                <th>
                    <xsl:apply-templates select="ead:head"/>
                </th>
                <td>
                    <xsl:apply-templates select="*[not(local-name() = 'head')]"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- main odd header -->
    <xsl:template match="ead:odd[1]/ead:head">

        <xsl:apply-templates/>

    </xsl:template>

    <!-- templates for handling the list -->
    <xsl:template match="ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 | ead:c07 | ead:c08 | ead:c09 |
	ead:c10 | ead:c11 | ead:c12">
        <xsl:choose>
            <xsl:when test="@level = 'series' or @level = 'subseries'">
                <div class="{@level}">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <dl class="{@level}">
                    <dt class="array">
                        <xsl:apply-templates select="ead:did/ead:container"/>
                    </dt>
                    <dd class="array">
                        <xsl:apply-templates select="ead:did/*[not(local-name() = 'container')]"/>
                        <xsl:apply-templates select="*[not(local-name()='did')]"/>
                    </dd>
                </dl>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:container">
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <span class="container">
                    <xsl:choose>
                        <xsl:when test="$metsBaseUrl and count(../..//ead:container)=1"><a href="http://visualmets.socialhistoryservices.org/mets2/rest/popup.html?metsId={concat($metsBaseUrl, normalize-space(text()), '.xml')}"
                               target="_blank">
                                <xsl:apply-templates/></a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <span class="container">
                    <xsl:choose>
                        <xsl:when test="$metsBaseUrl">
                            <a href="http://visualmets.socialhistoryservices.org/mets2/rest/popup.html?metsId={concat($metsBaseUrl, normalize-space(text()), '.xml')}"
                               target="_blank"><xsl:apply-templates/></a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:dsc//*/ead:unittitle">
        <xsl:if test="position() &gt; 1">
            <br/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <span class="unittitle">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="../../@level = 'series'">
                <h3>
                    <span class="unittitle">
                        <xsl:apply-templates/>
                    </span>
                </h3>
            </xsl:when>
            <xsl:when test="../../@level = 'subseries'">
                <xsl:choose>
                    <xsl:when
                            test="ancestor::ead:c04 | ancestor::ead:c05 | ancestor::ead:c06 | ancestor::ead:c07 |
                            ancestor::ead:c08 | ancestor::ead:c09 | ancestor::ead:c09 | ancestor::ead:c10 |
                             ancestor::ead:c11 | ancestor::ead:c12">
                        <h5>
                            <i>
                                <span class="unittitle">
                                    <xsl:apply-templates/>
                                </span>
                            </i>
                        </h5>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c03">
                        <h5>
                            <span class="unittitle">
                                <xsl:apply-templates/>
                            </span>
                        </h5>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c02">
                        <h4>
                            <span class="unittitle">
                                <xsl:apply-templates/>
                            </span>
                        </h4>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
                <span class="unittitle">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:physdesc">
        <span class="physdesc">
            <xsl:text>&#xA0;</xsl:text>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="ead:dsc/*//ead:physdesc">
        <xsl:variable name="content">
            <xsl:apply-templates/>
        </xsl:variable>
        <span class="physdesc">
            <xsl:text>&#xA0;</xsl:text><xsl:value-of select="normalize-space($content)"/><xsl:text>.</xsl:text>
        </span>
    </xsl:template>

    <!-- text and inline items -->
    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- BvS 2006-03-16: toegevoegd om, als de unittitle een file betreft, een spatie toe te voegen voor de datum -->
    <xsl:template match="ead:dsc//*/ead:unittitle/ead:unitdate">
        <xsl:choose>
            <xsl:when test="../../../@level = 'file'">
                &#0160;
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:note/ead:p">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="ead:emph">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <xsl:template match="ead:extref">
        <a href="{@href}" target="_blank">
            <xsl:value-of select="text()"/>
        </a>
    </xsl:template>

    <xsl:template match="ead:lb">
    `<br/> <br/>
    </xsl:template>

    <!-- lists -->
    <xsl:template match="ead:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:list/ead:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!-- table -->
    <xsl:template match="ead:table">
        <xsl:for-each select="ead:tgroup">
            <table class="tabledsc">
                <xsl:apply-templates/>
            </table>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="ead:colspec">
        <col width="{@colwidth}"/>
    </xsl:template>

    <xsl:template match="ead:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="ead:entry">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>


    <!-- named templates -->
    <xsl:template name="insertSpaces">
        <xsl:param name="spaces2insert"/>
        <xsl:choose>
            <xsl:when test="$spaces2insert &gt; 0">
                <xsl:text>&#xA0;</xsl:text>
                <xsl:call-template name="insertSpaces">
                    <xsl:with-param name="spaces2insert">
                        <xsl:value-of select="$spaces2insert - 1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ignoreHTML">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="contains($input,'&amp;')">
                <xsl:value-of select="substring-before($input,'&amp;')" disable-output-escaping="yes"/>&amp;
                <xsl:call-template name="ignoreHTML">
                    <xsl:with-param name="input">
                        <xsl:value-of select="substring-after($input,'&amp;')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
