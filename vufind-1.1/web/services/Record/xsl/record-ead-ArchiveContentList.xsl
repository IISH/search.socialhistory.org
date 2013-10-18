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
        <div id="arch">
            <xsl:for-each select="//ead:dsc[1]/ead:c01">
                <xsl:call-template name="cxx"/>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template name="cxx">
        <xsl:variable name="value">
            <xsl:apply-templates select="." mode="l"/>
        </xsl:variable>
        <xsl:if test="$value">
            <xsl:copy-of select="$value"/>
            <xsl:for-each select="*[starts-with(local-name(), 'c')]">
                <xsl:call-template name="cxx"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:dsc">
        <!--
                <h2>
                    <xsl:call-template name="aname">
                        <xsl:with-param name="value" select="normalize-space(ead:head)"/>
                        <xsl:with-param name="tag" select="name(ancestor::node())"/>
                    </xsl:call-template>
                </h2>
        -->
    </xsl:template>

    <xsl:template
            match="ead:c01|ead:c02|ead:c03|ead:c04|ead:c05|ead:c06|ead:c07|ead:c08|ead:c09|ead:c10|ead:c11|ead:c12"
            mode="l">
        <xsl:choose>
            <xsl:when test="@level = 'series' or @level = 'subseries'">
                <xsl:apply-templates select="*[not(starts-with(local-name(),'c'))]"/>
            </xsl:when>
            <xsl:otherwise>

                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="count(ead:did/ead:unittitle) &lt; 2">
                            <xsl:apply-templates select="ead:did/*[not(local-name() = 'unitid')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="ead:did/*[not(local-name() = 'unitid')]"/>
                            <!-- <ul>
                                 <xsl:for-each select="ead:did/ead:unittitle">
                                     <li>
                                         ccc<xsl:apply-templates select="."/>
                                     </li>
                                 </xsl:for-each>
                             </ul>-->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <div class="k{@level}">
                    <a class="b" name="{ead:did/ead:unitid}"><xsl:apply-templates select="ead:did/ead:unitid"/>.</a>
                </div>
                <xsl:if test="string-length($t)>1">
                    <div class="v{@level}">
                        <xsl:copy-of select="$t"/>
                    </div>
                </xsl:if>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:did">
        <xsl:apply-templates/>
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

    <xsl:template match="ead:unittitle">
        <xsl:choose>
            <xsl:when test="../../@level = 'file'">
                <xsl:apply-templates/><br/>
            </xsl:when>
            <xsl:when test="../../@level = 'series'">
                <h2>
                    <xsl:call-template name="aname">
                        <xsl:with-param name="value">
                            <xsl:apply-templates/>
                        </xsl:with-param>
                        <xsl:with-param name="tag" select="../../../ead:did/ead:unittitle/text()"/>
                    </xsl:call-template>
                </h2>
            </xsl:when>
            <xsl:when test="../../@level = 'subseries'">
                <xsl:choose>
                    <xsl:when
                            test="ancestor::ead:c04 | ancestor::ead:c05 | ancestor::ead:c06 | ancestor::ead:c07
                             | ancestor::ead:c08 | ancestor::ead:c09 | ancestor::ead:c09 | ancestor::ead:c10
                              | ancestor::ead:c11 | ancestor::ead:c12">
                        <h5>
                            <xsl:call-template name="aname">
                                <xsl:with-param name="value">
                                    <xsl:apply-templates/>
                                </xsl:with-param>
                                <xsl:with-param name="tag" select="../../../ead:did/ead:unittitle/text()"/>
                            </xsl:call-template>
                        </h5>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c02">
                        <h3>
                            <xsl:call-template name="aname">
                                <xsl:with-param name="value">
                                    <xsl:apply-templates/>
                                </xsl:with-param>
                                <xsl:with-param name="tag" select="../../../ead:did/ead:unittitle/text()"/>
                            </xsl:call-template>
                        </h3>
                    </xsl:when>
                    <xsl:when test="ancestor::ead:c03">
                        <h4>
                            <xsl:call-template name="aname">
                                <xsl:with-param name="value">
                                    <xsl:apply-templates/>
                                </xsl:with-param>
                                <xsl:with-param name="tag" select="../../../ead:did/ead:unittitle/text()"/>
                            </xsl:call-template>
                        </h4>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="../../@level = 'item'">
              <xsl:apply-templates/><br/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:unitdate">
        <xsl:value-of select="normalize-space(text())"/>
    </xsl:template>

    <xsl:template match="ead:physdesc">
       <xsl:apply-templates/><br/>
    </xsl:template>

    <xsl:template match="ead:note">
        <xsl:apply-templates /><br/>
    </xsl:template>

    <xsl:template match="ead:p">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="ead:extent">
        <xsl:text> </xsl:text>
        <xsl:value-of select="normalize-space(text())"/>
    </xsl:template>

</xsl:stylesheet>

