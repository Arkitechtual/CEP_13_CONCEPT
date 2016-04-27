<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalEncounterId"/>

    <xsl:template match="/">

        <xsl:variable name="reference_value">
            <xsl:if test="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference/@value != ''">
                <xsl:call-template name="get-content-display">
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                    <xsl:with-param name="tag-id"
                                    select="translate(entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference/@value,'#','')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="immunization">
            <xsl:choose>
                <xsl:when test="normalize-space($reference_value)">
                    <xsl:value-of select="normalize-space($reference_value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                            select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="immunization-code">
            <xsl:value-of
                    select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/@code"/>
        </xsl:variable>
        <xsl:variable name="immunization-code-source">
            <xsl:value-of
                    select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/@codeSystem"/>
        </xsl:variable>

        <xsl:variable name="date">
            <xsl:call-template name="format-date-node">
                <xsl:with-param name="date-node" select="entry/substanceAdministration/effectiveTime"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="Route">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/routeCode/@displayName">
                    <xsl:value-of select="entry/substanceAdministration/routeCode/@displayName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="entry/substanceAdministration/routeCode//originalText"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="Route_cd">
            <xsl:value-of select="entry/substanceAdministration/routeCode/@code"/>
        </xsl:variable>

        <xsl:variable name="Site">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/eapproachSiteCode/@displayName">
                    <xsl:value-of select="entry/substanceAdministration/approachSiteCode/@displayName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="entry/substanceAdministration/approachSiteCode//originalText"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="manufacturer-displayName"
                      select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturerOrganization/code/@displayName"/>
        <xsl:variable name="manufacturer-name"
                      select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturerOrganization/name"/>

        <xsl:variable name="Manufacturer">
            <xsl:choose>
                <xsl:when test="$manufacturer-displayName">
                    <xsl:value-of select="$manufacturer-displayName"/>
                </xsl:when>
                <xsl:when test="$manufacturer-name">
                    <xsl:value-of select="$manufacturer-name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text></xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of
                    select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturerOrganization/code/@displayName"/>
        </xsl:variable>

        <xsl:variable name="Lot">
            <xsl:value-of
                    select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/lotNumberText"/>
        </xsl:variable>

        <xsl:variable name="Note">
            <xsl:choose>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship[1]/act[code/@code='48767-8']/text/reference/@value != ''">
                    <xsl:for-each select="entry/substanceAdministration/entryRelationship/act[code/@code='48767-8']">
                        <xsl:if test="position()>1"><xsl:text>&lt;br/&gt;</xsl:text></xsl:if>
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./text/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                            select="entry/act/entryRelationship/observation/entryRelationship/act[code/@code='48767-8']/text"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="status">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/@negationInd = 'true'">
                    <xsl:text>Not Given</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="entry/substanceAdministration/statusCode/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="last-updated">
            <xsl:value-of
                    select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/family"/>
            <xsl:if test="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/given">
                <xsl:text></xsl:text>
                ,
                <xsl:for-each
                        select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:value-of select="."/>
                    <xsl:text></xsl:text>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/suffix">
                <xsl:text></xsl:text>
                <xsl:value-of
                        select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/suffix"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="last-updated-id">
            <xsl:value-of
                    select="entry/substanceAdministration/performer/assignedEntity/id/@extension"/>
        </xsl:variable>
        <xsl:variable name="last-updated-id-oid">
            <xsl:value-of
                    select="entry/substanceAdministration/performer/assignedEntity/id/@root"/>
        </xsl:variable>
        <xsl:variable name="last-updated-id-first">
            <xsl:for-each
                    select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/given">
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="last-updated-id-middle">
            <xsl:for-each
                    select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/given">
                <xsl:if test="not(position()=1)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="last-updated-id-last">
            <xsl:value-of
                    select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/family"/>
        </xsl:variable>
        <xsl:variable name="last-updated-id-suffix">
            <xsl:value-of
                    select="entry/substanceAdministration/performer/assignedEntity/assignedPerson/name/suffix"/>
        </xsl:variable>

        <xsl:variable name="source">
            <xsl:call-template name="get-source-tag">
                <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                <xsl:with-param name="author-tag" select="entry/substanceAdministration/author"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="dose_qty">
            <xsl:value-of select="entry/substanceAdministration/doseQuantity/@value"/>
        </xsl:variable>

        <xsl:variable name="dose_qty_unit">
            <xsl:value-of select="entry/substanceAdministration/doseQuantity/@unit"/>
        </xsl:variable>

        <xsl:variable name="encounter-number">
            <xsl:choose>
                <xsl:when test="$resolvedEncounterId != ''">
                    <xsl:value-of select="$resolvedEncounterId"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$globalEncounterId"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- insert the sql here for this row. -->
        <xsl:if test="$immunization!=''">
            <xsl:element name="immunization">
                <xsl:element name="SOURCE">
                    <xsl:value-of select="normalize-space($source)"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_NUM">
                    <xsl:value-of select="$encounter-number"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_ORIGIN">
                    <xsl:value-of select="$resolvedEncounterOrigin"/>
                </xsl:element>
                <xsl:element name="DOCUMENT_DATETIME">
                    <xsl:value-of select="$globalDocumentTs"/>
                </xsl:element>
                <xsl:element name="IMMUNIZATION">
                    <xsl:value-of select="normalize-space($immunization)"/>
                </xsl:element>
                <xsl:element name="IMMUNIZATION_CODE">
                    <xsl:value-of select="normalize-space($immunization-code)"/>
                </xsl:element>
                <xsl:element name="IMMUNIZATION_CODE_SOURCE">
                    <xsl:value-of select="normalize-space($immunization-code-source)"/>
                </xsl:element>
                <xsl:element name="DATE_GIVEN">
                    <xsl:value-of select="$date"/>
                </xsl:element>
                <xsl:element name="ROUTE">
                    <xsl:value-of select="normalize-space($Route)"/>
                </xsl:element>
                <xsl:element name="ROUTE_CODE">
                    <xsl:value-of select="normalize-space($Route_cd)"/>
                </xsl:element>
                <xsl:element name="SITE">
                    <xsl:value-of select="normalize-space($Site)"/>
                </xsl:element>
                <xsl:element name="MANUFACTURER">
                    <xsl:value-of select="normalize-space($Manufacturer)"/>
                </xsl:element>
                <xsl:element name="LOT">
                    <xsl:value-of select="normalize-space($Lot)"/>
                </xsl:element>
                <xsl:element name="DOSE_QTY">
                    <xsl:value-of select="normalize-space($dose_qty)"/>
                </xsl:element>
                <xsl:element name="DOSE_QTY_UNIT">
                    <xsl:value-of select="normalize-space($dose_qty_unit)"/>
                </xsl:element>
                <xsl:element name="NOTE">
                    <xsl:copy-of select="$Note"/>
                </xsl:element>
                <xsl:element name="STATUS">
                    <xsl:value-of select="normalize-space($status)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_ID">
                    <xsl:value-of select="normalize-space($last-updated-id)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_ID_OID">
                    <xsl:value-of select="normalize-space($last-updated-id-oid)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_FIRST">
                    <xsl:value-of select="normalize-space($last-updated-id-first)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_MIDDLE">
                    <xsl:value-of select="normalize-space($last-updated-id-middle)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_LAST">
                    <xsl:value-of select="normalize-space($last-updated-id-last)"/>
                </xsl:element>
                <xsl:element name="LAST_UPDATED_BY_SUFFIX">
                    <xsl:value-of select="normalize-space($last-updated-id-suffix)"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>