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

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation[@codeSystem='2.16.840.1.113883.6.88']/@displayName">
                    <xsl:value-of select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation[@codeSystem='2.16.840.1.113883.6.88']/@displayName" />
                </xsl:when>
                <xsl:when
                        test="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference/@value !=''">
                    <xsl:call-template name="get-content-display">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"
                                        select="translate(entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/originalText/reference/@value,'#','')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                            select="entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/@displayName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="status">
            <xsl:choose>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code='55561003'">
                    <xsl:text>Active</xsl:text>
                </xsl:when>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code='421139008'">
                    <xsl:text>On Hold</xsl:text>
                </xsl:when>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code='392521001'">
                    <xsl:text>Prior History</xsl:text>
                </xsl:when>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code='73425007'">
                    <xsl:text>No Longer Active</xsl:text>
                </xsl:when>
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@displayName!=''">
                    <xsl:value-of
                            select="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@displayName"/>
                </xsl:when>
                <xsl:when
                        test="not(entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code)">
                    <xsl:text>Active</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                            select="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="status_cd">
            <xsl:choose><!--default to active if no status sent-->
                <xsl:when
                        test="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code != ''">
                    <xsl:value-of
                            select="entry/substanceAdministration/entryRelationship/observation/code[@code='33999-4']/../value/@code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>55561003</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="formated-date">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/effectiveTime/low/@value != ''">
                    <xsl:value-of select="entry/substanceAdministration/effectiveTime/low/@value"/>
                </xsl:when>
                <xsl:when test="entry/substanceAdministration/effectiveTime/high/@value != ''">
                    <xsl:value-of select="entry/substanceAdministration/effectiveTime/high/@value"/>
                </xsl:when>
                <xsl:when test="entry/substanceAdministration/entryRelationship/supply/effectiveTime/low/@value">
                    <xsl:value-of select="entry/substanceAdministration/entryRelationship/supply/effectiveTime/low/@value"/>
                </xsl:when>
                <xsl:when test="entry/substanceAdministration/entryRelationship/supply/effectiveTime/high/@value">
                    <xsl:value-of select="entry/substanceAdministration/entryRelationship/supply/effectiveTime/high/@value"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="age-date">
            <xsl:value-of select="entry/substanceAdministration/effectiveTime/low/@value"/>
        </xsl:variable>

        <xsl:variable name="source">
            <xsl:call-template name="get-source-tag">
                <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                <xsl:with-param name="author-tag" select="entry/substanceAdministration/author"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ordering-provider-id">
            <xsl:value-of
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/id/@extension"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-oid">
            <xsl:value-of
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/id/@root"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-first">
            <xsl:for-each
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/name/given">
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ordering-provider-middle">
            <xsl:for-each
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/name/given">
                <xsl:if test="not(position()=1)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ordering-provider-last">
            <xsl:value-of
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/name/family"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-suffix">
            <xsl:value-of
                    select="entry/substanceAdministration/entryRelationship/supply/author/assignedAuthor/assignedPerson/name/suffix"/>
        </xsl:variable>

        <xsl:variable name="patient-instructions">
            <xsl:if test="entry/substanceAdministration/entryRelationship/act[code/@code = 'PINSTRUCT']/text/reference/@value">
                <xsl:call-template name="get-content-display">
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                    <xsl:with-param name="tag-id"
                                    select="translate(entry/substanceAdministration/entryRelationship/act[code/@code = 'PINSTRUCT']/text/reference/@value,'#','')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="administration" select="entry/substanceAdministration"/>

        <xsl:variable name="material"
                      select="$administration/consumable/manufacturedProduct/manufacturedMaterial"/>

        <xsl:variable name="prn-ind">
            <xsl:choose>
                <xsl:when test="$administration/precondition">
                    <xsl:text>1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="detail_line">
            <xsl:choose>
                <xsl:when test="entry/substanceAdministration/text/reference/@value != ''">
                    <xsl:call-template name="get-content-display">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"
                                        select="translate(entry/substanceAdministration/text/reference/@value,'#','')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="entry/substanceAdministration/text != ''">
                    <xsl:value-of
                            select="entry/substanceAdministration/text"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

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

        <!-- record only current records -->
        <!-- leave it up to the view what status to show <xsl:if test="$statusUpCase = 'ACTIVE' or $statusUpCase = 'DOCUMENTED' or $statusUpCase = 'ORDERED' or $status_cd='55561003'">-->

        <!-- insert the sql here for this row. -->
        <xsl:if test="$name!=''">
            <xsl:element name="medication">
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
                <!--<xsl:element name="ORDER_ALIAS">
                    <xsl:value-of select="normalize-space($material/code/originalText)"/>
                </xsl:element>-->
                <xsl:element name="MEDICATION">
                    <xsl:value-of select="normalize-space($name)"/>
                </xsl:element>
                <xsl:element name="MEDICATION_CODE">
                    <xsl:choose>
                        <xsl:when test="$material/code/@code and $material/code/@code !=''">
                            <xsl:value-of select="normalize-space($material/code/@code)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>OTH</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="MEDICATION_CODE_SOURCE">
                    <xsl:value-of select="normalize-space($material/code/@codeSystem)"/>
                </xsl:element>
                <xsl:element name="DOSE_QTY">
                    <xsl:call-template name="get-qty">
                        <xsl:with-param name="qty" select="$administration/doseQuantity"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="DOSE_QTY_UNIT">
                    <xsl:call-template name="get-qty-unit">
                        <xsl:with-param name="qty-unit" select="$administration/doseQuantity"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="RATE_QTY">
                    <xsl:value-of select="normalize-space($administration/rateQuantity/@value)"/>
                </xsl:element>
                <xsl:element name="RATE_QTY_UNIT">
                    <xsl:value-of select="normalize-space($administration/rateQuantity/@unit)"/>
                </xsl:element>
                <xsl:element name="PRN_IND">
                    <xsl:value-of select="$prn-ind"/>
                </xsl:element>
                <xsl:element name="PRN_TEXT">
                    <xsl:value-of
                            select="normalize-space($administration/precondition/criterion/text/reference/@value)"/>
                </xsl:element>
                <xsl:element name="ROUTE">
                    <xsl:value-of select="normalize-space($administration/routeCode/@code)"/>
                </xsl:element>
                <xsl:element name="ROUTE_DISPLAY">
                    <xsl:value-of select="normalize-space($administration/routeCode/@displayName)"/>
                </xsl:element>
                <xsl:element name="DISPENSE">
                    <xsl:value-of
                            select="normalize-space($administration/entryRelationship/supply/quantity/@value)"/>
                </xsl:element>
                <xsl:element name="DISPENSE_UNITS">
                    <xsl:value-of
                            select="normalize-space($administration/entryRelationship/supply/quantity/@unit)"/>
                </xsl:element>
                <xsl:element name="REFILLS">
                    <xsl:value-of
                            select="normalize-space($administration/entryRelationship/supply/repeatNumber/@value)"/>
                </xsl:element>
                <xsl:element name="STATUS">
                    <xsl:value-of select="$status"/>
                </xsl:element>
                <xsl:element name="STATUS_CODE">
                    <xsl:value-of select="$status_cd"/>
                </xsl:element>
                <xsl:element name="INSTRUCTIONS">
                    <xsl:value-of select="normalize-space($patient-instructions)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_ID">
                    <xsl:value-of select="normalize-space($ordering-provider-id)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_ID_OID">
                    <xsl:value-of select="normalize-space($ordering-provider-oid)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_FIRST">
                    <xsl:value-of select="normalize-space($ordering-provider-first)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_MIDDLE">
                    <xsl:value-of select="normalize-space($ordering-provider-middle)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_LAST">
                    <xsl:value-of select="normalize-space($ordering-provider-last)"/>
                </xsl:element>
                <xsl:element name="ORDERING_PROVIDER_SUFFIX">
                    <xsl:value-of select="normalize-space($ordering-provider-suffix)"/>
                </xsl:element>
                <xsl:element name="ORDER_DATE">
                    <xsl:value-of select="$formated-date"/>
                </xsl:element>
                <xsl:element name="DETAIL_LINE">
                    <xsl:value-of select="$detail_line"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>