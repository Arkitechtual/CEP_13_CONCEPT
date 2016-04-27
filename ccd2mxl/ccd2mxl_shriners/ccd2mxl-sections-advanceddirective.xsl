<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalAssigningAuthorityName"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalServiceEventStart"/>
    <xsl:param name="globalServiceEventEnd"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalTextSectionIdentificator"/>
    <xsl:param name="globalEncounterId"/>

    <xsl:template match="/">

        <xsl:variable name="order-name"><xsl:text>Advance Directives</xsl:text></xsl:variable>
        <xsl:variable name="order-code"><xsl:text>42348-3</xsl:text></xsl:variable>
        <xsl:variable name="order-code-source"><xsl:text>2.16.840.1.113883.6.1</xsl:text></xsl:variable>

        <xsl:variable name="report-identifier">
            <xsl:choose>
                <xsl:when test="./entry/observation/id/@extension !=''">
                    <xsl:value-of select="./entry/observation/id/@extension"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./entry/observation/id/@root"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-code">
            <xsl:choose>
                <xsl:when test="./entry/observation/code/@code != ''"><xsl:value-of select="./entry/observation/code/@code"/></xsl:when>
                <xsl:otherwise><xsl:text>42348-3</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-code-source">
            <xsl:choose>
                <xsl:when test="./entry/observation/code/@codeSystem != ''"><xsl:value-of select="./entry/observation/code/@codeSystem"/></xsl:when>
                <xsl:otherwise><xsl:text>2.16.840.1.113883.6.1</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-name">
            <xsl:choose>
                <xsl:when test="./entry/observation/code/@displayName != ''">
                    <xsl:value-of select="./entry/observation/code/@displayName"/>
                </xsl:when>
                <xsl:otherwise><xsl:text>Advance Directives</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-datetime">
            <xsl:choose>
                <xsl:when test="./entry/observation/effectiveTime/@value !=''">
                    <xsl:value-of select="./entry/observation/effectiveTime/@value"/>
                </xsl:when>
                <xsl:when test="./entry/observation/effectiveTime/low/@value !=''">
                    <xsl:value-of select="./entry/observation/effectiveTime/low/@value"/>
                </xsl:when>
                <xsl:when test="./entry/observation/effectiveTime/high/@value !=''">
                    <xsl:value-of select="./entry/observation/effectiveTime/high/@value"/>
                </xsl:when>
                <xsl:when test="$globalServiceEventEnd !=''">
                    <xsl:value-of select="$globalServiceEventEnd"/>
                </xsl:when>
                <xsl:when test="$globalServiceEventStart !=''">
                    <xsl:value-of select="$globalServiceEventStart"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$globalDocumentTs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="source">
            <xsl:call-template name="get-source-tag">
                <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                <xsl:with-param name="author-tag" select="./entry/observation/author"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="report-text-temp">
            <xsl:choose>
                <xsl:when test="./entry/observation/text/reference/@value !=''">
                    <xsl:call-template name="get-content-display" >
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id" select="translate(./entry/observation/text/reference/@value,'#','')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="./entry/observation/code/originalText/reference/@value !=''">
                    <xsl:call-template name="get-content-display" >
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id" select="translate(./entry/observation/code/originalText//reference/@value,'#','')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="./entry/observation/value/@displayName !=''">
                    <xsl:value-of select="./entry/observation/value/@displayName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./entry/observation/value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-text">
            <xsl:choose>
                <xsl:when test="normalize-space($report-text-temp) !=''">
                    <xsl:value-of select="$report-text-temp"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="get-content-display" >
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"><xsl:value-of select="$globalTextSectionIdentificator"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-text-data-type">
            <xsl:choose>
                <xsl:when test="entry/observation/value/@xsi:type !=''">
                    <xsl:value-of
                            select="entry/observation/value/@xsi:type"/>
                </xsl:when>
                <xsl:otherwise><xsl:text>ST</xsl:text></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="status">
            <xsl:choose>
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code='55561003'">
                    <xsl:text>Active</xsl:text>
                </xsl:when>
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code='421139008'">
                    <xsl:text>On Hold</xsl:text>
                </xsl:when>
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code='392521001'">
                    <xsl:text>Prior History</xsl:text>
                </xsl:when>
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code='73425007'">
                    <xsl:text>No Longer Active</xsl:text>
                </xsl:when>
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@displayName!=''">
                    <xsl:value-of
                            select="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@displayName"/>
                </xsl:when>
                <xsl:when
                        test="not(./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code)">
                    <xsl:text>Active</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                            select="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="status_cd">
            <xsl:choose><!--default to active if no status sent-->
                <xsl:when
                        test="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code != ''">
                    <xsl:value-of
                            select="./entry/observation/entryRelationship/observation/code[@code='33999-4']/../value/@code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>55561003</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
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

        <!-- insert the SQL here for this row. -->
        <xsl:element name="result">
            <xsl:element name="SUB_TYPE">
                <xsl:text>advanced-directive</xsl:text>
            </xsl:element>
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
            <xsl:element name="DATA_TYPE">
                <xsl:text>advanced-directive</xsl:text>
            </xsl:element>
            <xsl:element name="RESULT_ID">
                <xsl:value-of select="$report-identifier"/>
            </xsl:element>
            <xsl:element name="RESULT">
                <xsl:value-of select="$report-name"/>
            </xsl:element>
            <xsl:element name="RESULT_CODE">
                <xsl:value-of select="$report-code"/>
            </xsl:element>
            <xsl:element name="RESULT_CODE_SOURCE">
                <xsl:value-of select="$report-code-source"/>
            </xsl:element>
            <xsl:element name="RESULT_DATE">
                <xsl:value-of select="$report-datetime"/>
            </xsl:element>
            <xsl:element name="EVENT_TITLE">
                <xsl:text>Advance Directives</xsl:text>
            </xsl:element>
            <xsl:element name="VALUE">
                <xsl:value-of select="$report-text"/>
            </xsl:element>
            <xsl:element name="VALUE_DATA_TYPE">
                <xsl:value-of select="$report-text-data-type"/>
            </xsl:element>
            <xsl:element name="STATUS">
                <xsl:value-of select="$status"/>
            </xsl:element>
            <xsl:element name="ORDER_NAME">
                <xsl:value-of select="$order-name"/>
            </xsl:element>
            <xsl:element name="ORDER_CODE">
                <xsl:value-of select="$order-code"/>
            </xsl:element>
            <xsl:element name="ORDER_CODE_SOURCE">
                <xsl:value-of select="$order-code-source"/>
            </xsl:element>

        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
