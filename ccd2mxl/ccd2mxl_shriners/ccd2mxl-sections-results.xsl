<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rtf="http://www.browsersoft.com/">

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

    <xsl:template name="build-section-results">
        <xsl:param name="organizer" />
        <xsl:param name="organizer-type" />

        <xsl:call-template name="results-details">
            <xsl:with-param name="organizer" select="$organizer"/>
            <xsl:with-param name="organizer-type" select="$organizer-type"/>
        </xsl:call-template>


    </xsl:template>

    <xsl:template name="results-details">
        <xsl:param name="organizer"/>
        <xsl:param name="organizer-type"/>


        <xsl:for-each select="$organizer">

            <xsl:variable name="report-name" select="$organizer/code/@displayName"/>

            <xsl:variable name="performer-id">
                <xsl:value-of
                        select="component/observation/performer/assignedEntity/assignedPerson/id/@extension"/>
            </xsl:variable>
            <xsl:variable name="performer-oid">
                <xsl:value-of
                        select="component/observation/performer/assignedEntity/assignedPerson/id/@root"/>
            </xsl:variable>
            <xsl:variable name="performer-first">
                <xsl:for-each select="component/observation/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="position()=1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="performer-middle">
                <xsl:for-each select="component/observation/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="not(position()=1)">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="performer-last">
                <xsl:value-of
                        select="component/observation/performer/assignedEntity/assignedPerson/name/family"/>
            </xsl:variable>
            <xsl:variable name="performer-suffix">
                <xsl:value-of
                        select="component/observation/performer/assignedEntity/assignedPerson/name/suffix"/>
            </xsl:variable>

            <xsl:variable name="verifier-id">
                <xsl:value-of
                        select="./author/assignedAuthor/assignedPerson/id/@extension"/>
            </xsl:variable>
            <xsl:variable name="verifier-oid">
                <xsl:value-of
                        select="./author/assignedAuthor/assignedPerson/id/@root"/>
            </xsl:variable>
            <xsl:variable name="verifier-first">
                <xsl:for-each select="./author/assignedAuthor/assignedPerson/name/given">
                    <xsl:if test="position()=1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="verifier-middle">
                <xsl:for-each select="./author/assignedAuthor/assignedPerson/name/given">
                    <xsl:if test="not(position()=1)">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="verifier-last">
                <xsl:value-of
                        select="./author/assignedAuthor/assignedPerson/name/family"/>
            </xsl:variable>
            <xsl:variable name="verifier-suffix">
                <xsl:value-of
                        select="./author/assignedAuthor/assignedPerson/name/suffix"/>
            </xsl:variable>



            <xsl:variable name="ordering-provider-id">
                <xsl:value-of
                        select="./participant/participantRole/playingEntity/id/@extension"/>
            </xsl:variable>
            <xsl:variable name="ordering-provider-oid">
                <xsl:value-of
                        select="./participant/participantRole/playingEntity/id/@root"/>
            </xsl:variable>
            <xsl:variable name="ordering-provider-first">
                <xsl:for-each select="./participant/participantRole/playingEntity/name/given">
                    <xsl:if test="position()=1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="ordering-provider-middle">
                <xsl:for-each select="./participant/participantRole/playingEntity/name/given">
                    <xsl:if test="not(position()=1)">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="ordering-provider-last">
                <xsl:value-of
                        select="./participant/participantRole/playingEntity/name/family"/>
            </xsl:variable>
            <xsl:variable name="ordering-provider-suffix">
                <xsl:value-of
                        select="./participant/participantRole/playingEntity/name/suffix"/>
            </xsl:variable>



            <xsl:variable name="report-identifier">
                <xsl:choose>
                    <xsl:when test="component/observation/id/@extension !=''">
                        <xsl:value-of select="component/observation/id/@extension"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="component/observation/id/@root"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="report-source" select="component/observation/id/@codeSystem"/>
            <xsl:variable name="report-code" select="component/observation/code/@code"/>
            <xsl:variable name="report-code-source" select="component/observation/code[0]/@codeSystem"/>

            <xsl:variable name="report-date">
                <xsl:value-of select="component/observation/effectiveTime/@value"/>
            </xsl:variable>

            <xsl:variable name="patient-type"
                          select="normalize-space(observation/id[@root='ENCNTRPATTYPE']/@extension)"/>
            <xsl:variable name="encounter_num">
                <xsl:choose>
                    <xsl:when test="$organizer/component/encounter/id/@extension !=''"><xsl:value-of select="normalize-space($organizer/component/encounter/id/@extension)"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(observation/id[@root='ENCNTRID']/@extension)"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="enc_location"
                          select="normalize-space(observation/id[@root='ENCNTRLOC']/@extension)"/>


            <xsl:variable name="source">
                <xsl:call-template name="get-source-tag">
                    <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                    <xsl:with-param name="author-tag" select="$organizer/author"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="report-status" select="component/observation/statusCode/@code"/>
            <xsl:variable name="report-title"
                          select="normalize-space(observation/id[@root='REPORTTITLE']/@extension)"/>

            <xsl:variable name="age-results">
                <xsl:call-template name="print-age">
                    <xsl:with-param name="first-date"
                                    select="component/observation/effectiveTime/@value"/>
                    <xsl:with-param name="print-month" select="0"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="report-text">
                <xsl:for-each select="component/observation/entryRelationship/act/text/reference">
                    <xsl:if test="contains($source,'1.3.6.1.4.1.22812.4.73547.0') and ./@value !=''">
                        <xsl:call-template name="get-content-display" >
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id" select="translate(./@value,'#','')" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="component/observation/text/reference">
                    <xsl:if test="./@value !=''">
                        <xsl:call-template name="get-content-display" >
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id" select="translate(./@value,'#','')" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="component/observation/value">
                    <xsl:if test=". !=''">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>

            <xsl:variable name="report-text-data-type">
                <xsl:value-of select="component/observation/value/@*"/>
            </xsl:variable>

            <xsl:variable name="perform-date">
                <xsl:value-of select="component/observation/performer/time/low/@value"/>
            </xsl:variable>

            <xsl:variable name="verify-date">
                <xsl:value-of select="normalize-space(observation/author/time/low/@value)"/>
            </xsl:variable>

            <xsl:variable name="report-note"
                          select="component/observation/entryRelationship/act/text"/>


            <xsl:variable name="statusUpCase" select="translate($report-status, $smallcase, $uppercase)"/>

            <xsl:variable name="encounter-number">
                <xsl:choose>
                    <xsl:when test="$resolvedEncounterId != ''">
                        <xsl:value-of select="$resolvedEncounterId"/>
                    </xsl:when>
                    <xsl:when test="$encounter_num != ''">
                        <xsl:value-of select="$encounter_num"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$globalEncounterId"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <!-- skip bad records -->
            <!--<xsl:if test="$statusUpCase != 'IN ERROR'">-->

            <!-- insert the SQL here for this row. -->
            <xsl:element name="result">
                <xsl:element name="SUB_TYPE">
                    <xsl:value-of select="$organizer-type"/>
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
                    <xsl:value-of select="$organizer-type"/>
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
                <xsl:element name="RESULT_DATE">
                    <xsl:value-of select="$report-date"/>
                </xsl:element>
                <xsl:element name="COMMENTS">
                    <xsl:value-of select="$report-note"/>
                </xsl:element>
                <xsl:element name="RESULT_CODE_SOURCE">
                    <xsl:value-of select="$report-code-source"/>
                </xsl:element>
                <xsl:element name="EVENT_TITLE">
                    <xsl:value-of select="$report-title"/>
                </xsl:element>
                <xsl:element name="IBOX_CAPTION">
                    <xsl:value-of select="$report-title"/>
                </xsl:element>
                <xsl:element name="VALUE">
                    <xsl:copy-of select="$report-text"/>
                </xsl:element>
                <xsl:element name="RESULT_IBOX_TEXT">
                    <xsl:copy-of select="$report-text"/>
                </xsl:element>
                <xsl:element name="VALUE_DATA_TYPE">
                    <xsl:value-of select="$report-text-data-type"/>
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
                <xsl:element name="PERFORMER_ID">
                    <xsl:value-of select="normalize-space($performer-id)"/>
                </xsl:element>
                <xsl:element name="PERFORMER_ID_OID">
                    <xsl:value-of select="normalize-space($performer-oid)"/>
                </xsl:element>
                <xsl:element name="PERFORMER_FIRST">
                    <xsl:value-of select="normalize-space($performer-first)"/>
                </xsl:element>
                <xsl:element name="PERFORMER_MIDDLE">
                    <xsl:value-of select="normalize-space($performer-middle)"/>
                </xsl:element>
                <xsl:element name="PERFORMER_LAST">
                    <xsl:value-of select="normalize-space($performer-last)"/>
                </xsl:element>
                <xsl:element name="PERFORMER_SUFFIX">
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
                <xsl:element name="VERIFY_DATE">
                    <xsl:value-of select="$verify-date"/>
                </xsl:element>
                <xsl:element name="PERFORM_DATE">
                    <xsl:value-of select="$perform-date"/>
                </xsl:element>
                <xsl:element name="PATIENT_TYPE">
                    <xsl:value-of select="normalize-space($patient-type)"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_NUM">
                    <xsl:value-of select="normalize-space($encounter_num)"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_LOCATION">
                    <xsl:value-of select="normalize-space($enc_location)"/>
                </xsl:element>
                <xsl:element name="STATUS">
                    <xsl:value-of select="$report-status"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
