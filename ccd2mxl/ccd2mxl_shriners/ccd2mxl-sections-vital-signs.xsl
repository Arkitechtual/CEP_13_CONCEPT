<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalStatusCode"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalEncounterId"/>

    <xsl:template match="/">

        <xsl:for-each select="./entry/organizer">
            <xsl:variable name="status" select="./statusCode/@code"/>
            <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

            <xsl:for-each select="./component" >
                <xsl:for-each select="./observation">
                    <xsl:variable name="source">
                        <xsl:call-template name="get-source-tag">
                            <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                            <xsl:with-param name="author-tag" select="./../../author"/> <!-- TODO: autor? -->
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="measurement-id" select="normalize-space(./id/@extension)"/>
                    <xsl:variable name="measurement-name">
                        <xsl:choose>
                            <xsl:when test="./code/@displayName !=''">
                                <xsl:value-of select="normalize-space(./code/@displayName)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(./code/originalText)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="measurement-code" select="normalize-space(./code/@code)"/>
                    <xsl:variable name="measurement-code-source" select="normalize-space(./code/@codeSystem)"/>

                    <xsl:variable name="meas" select="normalize-space(./code/@displayName)"/>

                    <xsl:variable name="measu" select="upper-case($meas)"/>
                    <xsl:variable name="route">
                        <xsl:if test="fn:matches($measu,'TEMPERATURE')">
                            <xsl:value-of select="fn:tokenize($measu,'TEMPERATURE')[2]"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="site">
                        <xsl:choose>
                            <xsl:when test="fn:matches($measu,'PULSE RATE')">
                                <xsl:value-of select="fn:tokenize($measu,'PULSE RATE')[1]"/>
                            </xsl:when>
                            <xsl:when test="fn:matches($measu,'BLOOD PRESSURE')">
                                <xsl:value-of select="fn:tokenize($measu,'BLOOD PRESSURE')[1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text></xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="reference_value">
                        <xsl:if test="./value/originalText/reference/@value != ''">
                            <xsl:call-template name="get-content-display">
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id"
                                                select="translate(./value/originalText/reference/@value,'#','')"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="value_data_type" select="./value/@xsi:type"/>
                    <xsl:variable name="value">
                        <xsl:choose>
                            <xsl:when test="$value_data_type = 'CD'">
                                <xsl:choose>
                                    <xsl:when test="normalize-space($reference_value) != ''">
                                        <xsl:value-of select="normalize-space($reference_value)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./value/@displayName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="./value/high/@value">
                                        &lt;
                                        <xsl:if test="./value/high/@inclusive='true'">=</xsl:if>
                                        <xsl:value-of select="./value/high/@value"/>
                                    </xsl:when>
                                    <xsl:when test="./value/low/@value">
                                        &gt;
                                        <xsl:if test="./value/low/@inclusive='true'">=</xsl:if>
                                        <xsl:value-of select="./value/low/@value"/>
                                    </xsl:when>
                                    <xsl:when test="./value/@value">
                                        <xsl:value-of select="./value/@value"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="./value/originalText/reference/@value != ''">
                                                <xsl:call-template name="get-content-display">
                                                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                                    <xsl:with-param name="tag-id"
                                                                    select="translate(./value/originalText/reference/@value,'#','')"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./value"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:variable>

                    <xsl:variable name="value_unit">
                        <xsl:choose>
                            <xsl:when test="./value/high/@value">
                                <xsl:call-template name="get-value-units">
                                    <xsl:with-param name="valueRef" select="./value/high"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="./value/low/@value">
                                <xsl:call-template name="get-value-units">
                                    <xsl:with-param name="valueRef" select="./value/low"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="get-value-units">
                                    <xsl:with-param name="valueRef" select="./value"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="range">
                        <xsl:choose>
                            <xsl:when test="./referenceRange/observationRange/text/reference/@value != ''">
                                <xsl:call-template name="get-content-display">
                                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                    <xsl:with-param name="tag-id"
                                                    select="translate(./referenceRange/observationRange/text/reference/@value,'#','')"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(./referenceRange/observationRange)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="low-value-from-range">
                        <xsl:if test="contains($range,'-')">
                            <xsl:value-of select="normalize-space(tokenize($range,'-')[1])"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="high-value-from-range">
                        <xsl:if test="contains($range,'-')">
                            <xsl:value-of select="normalize-space(tokenize($range,'-')[2])" />
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="low-value">
                        <xsl:choose>
                            <xsl:when test="./referenceRange/observationRange/value/low/@value">
                                <xsl:value-of select="./referenceRange/observationRange/value/low/@value"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="high-value"
                                  select="normalize-space(./referenceRange/observationRange/value/high/@value)"/>

                    <xsl:variable name="report-range-low">
                        <xsl:choose>
                            <xsl:when test="$low-value!=''">
                                <xsl:value-of select="$low-value"/>
                            </xsl:when>
                            <xsl:when test="$low-value-from-range!=''">
                                <xsl:value-of select="$low-value-from-range"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./referenceRange/observationRange/text"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="report-range-high">
                        <xsl:choose>
                            <xsl:when test="$high-value">
                                <xsl:value-of select="$high-value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="translate($high-value-from-range,translate($high-value-from-range, '0123456789.', ''), '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="interpretationCode">
                        <xsl:value-of select="./interpretationCode/@code"/>
                    </xsl:variable>
                    <xsl:variable name="interpretation">
                        <xsl:value-of select="./interpretationCode/@displayName"/>
                    </xsl:variable>


                    <xsl:variable name="performer-id">
                        <xsl:value-of
                                select="./performer/assignedEntity/id/@extension"/>
                    </xsl:variable>
                    <xsl:variable name="performer-oid">
                        <xsl:value-of
                                select="./performer/assignedEntity/id/@root"/>
                    </xsl:variable>
                    <xsl:variable name="performer-first">
                        <xsl:for-each select="./performer/assignedEntity/assignedPerson/name/given">
                            <xsl:if test="position()=1">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="performer-middle">
                        <xsl:for-each select="./performer/assignedEntity/assignedPerson/name/given">
                            <xsl:if test="not(position()=1)">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="performer-last">
                        <xsl:value-of
                                select="./performer/assignedEntity/assignedPerson/name/family"/>
                    </xsl:variable>
                    <xsl:variable name="performer-suffix">
                        <xsl:value-of
                                select="./performer/assignedEntity/assignedPerson/name/suffix"/>
                    </xsl:variable>

                    <xsl:variable name="verifier-id">
                        <xsl:value-of
                                select="./informant/assignedEntity/id/@extension"/>
                    </xsl:variable>
                    <xsl:variable name="verifier-oid">
                        <xsl:value-of
                                select="./informant/assignedEntity/id/@root"/>
                    </xsl:variable>
                    <xsl:variable name="verifier-first">
                        <xsl:for-each select="./informant/assignedEntity/assignedPerson/name/given">
                            <xsl:if test="position()=1">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="verifier-middle">
                        <xsl:for-each select="./informant/assignedEntity/assignedPerson/name/given">
                            <xsl:if test="not(position()=1)">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="verifier-last">
                        <xsl:value-of
                                select="./informant/assignedEntity/assignedPerson/name/family"/>
                    </xsl:variable>
                    <xsl:variable name="verifier-suffix">
                        <xsl:value-of
                                select="./informant/assignedEntity/assignedPerson/name/suffix"/>
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
                    <xsl:if test="$value !=''">
                        <xsl:element name="vital">
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
                            <xsl:element name="MEASUREMENT_ID">
                                <xsl:value-of select="$measurement-id"/>
                            </xsl:element>
                            <xsl:element name="MEASUREMENT_NAME">
                                <xsl:value-of select="$measurement-name"/>
                            </xsl:element>
                            <xsl:element name="MEASUREMENT_CODE">
                                <xsl:value-of select="$measurement-code"/>
                            </xsl:element>
                            <xsl:element name="MEASUREMENT_CODE_SOURCE">
                                <xsl:value-of select="$measurement-code-source"/>
                            </xsl:element>
                            <xsl:element name="ROUTE">
                                <xsl:value-of select="normalize-space($route)"/>
                            </xsl:element>
                            <xsl:element name="SITE">
                                <xsl:value-of select="normalize-space($site)"/>
                            </xsl:element>
                            <xsl:element name="VALUE">
                                <xsl:value-of select="$value"/>
                            </xsl:element>
                            <xsl:element name="VALUE_UNIT">
                                <xsl:value-of select="$value_unit"/>
                            </xsl:element>
                            <xsl:element name="VALUE_DATA_TYPE">
                                <xsl:value-of select="$value_data_type"/>
                            </xsl:element>
                            <xsl:element name="LOW_VALUE">
                                <xsl:value-of select="$report-range-low"/>
                            </xsl:element>
                            <xsl:element name="HIGH_VALUE">
                                <xsl:value-of select="$report-range-high"/>
                            </xsl:element>
                            <xsl:element name="INTERPRETATION">
                                <xsl:value-of select="$interpretation"/>
                            </xsl:element>
                            <xsl:element name="INTERPRETATION_CODE">
                                <xsl:value-of select="$interpretationCode"/>
                            </xsl:element>
                            <xsl:element name="STATUS">
                                <xsl:value-of select="$globalStatusCode"/>
                            </xsl:element>
                            <xsl:element name="OBSERVATION_DATE">
                                <xsl:value-of select="./effectiveTime/@value"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_ID">
                                <xsl:value-of select="normalize-space($performer-id)"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_ID_OID">
                                <xsl:value-of select="normalize-space($performer-oid)"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_FIRST">
                                <xsl:value-of select="normalize-space($performer-first)"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_MIDDLE">
                                <xsl:value-of select="normalize-space($performer-middle)"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_LAST">
                                <xsl:value-of select="normalize-space($performer-last)"/>
                            </xsl:element>
                            <xsl:element name="RESULTED_BY_SUFFIX">
                                <xsl:value-of select="normalize-space($performer-suffix)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_ID">
                                <xsl:value-of select="normalize-space($verifier-id)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_ID_OID">
                                <xsl:value-of select="normalize-space($verifier-oid)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_FIRST">
                                <xsl:value-of select="normalize-space($verifier-first)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_MIDDLE">
                                <xsl:value-of select="normalize-space($verifier-middle)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_LAST">
                                <xsl:value-of select="normalize-space($verifier-last)"/>
                            </xsl:element>
                            <xsl:element name="VERIFIER_SUFFIX">
                                <xsl:value-of select="normalize-space($verifier-suffix)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>