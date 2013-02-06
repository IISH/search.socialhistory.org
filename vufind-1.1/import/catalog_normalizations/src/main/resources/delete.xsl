<?xml version="1.0" encoding="UTF-8"?>

<!--
This stylesheet corrects some irregularities from the Evergreen OAI export.
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <!-- Should we remove this record ? -->
    <xsl:template match="//marc:datafield[@tag='852']/marc:subfield[@code='j']"/>

</xsl:stylesheet>