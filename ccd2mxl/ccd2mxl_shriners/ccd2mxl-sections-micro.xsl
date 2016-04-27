<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
    <xsl:param name="globalAuthor"/>

    <xsl:param name="globalOrganizerDisplayName"/>
    <xsl:param name="globalOrganizerCode"/>
    <xsl:param name="globalOrganizerCodeSystem"/>
    <xsl:param name="globalOrganizerOriginalText"/>
    <xsl:param name="globalOrganizerIdOriginalText"/>
    <xsl:param name="globalObservationCount"/>
    <xsl:param name="globalEncounterId"/>

    <xsl:template name="build-section-micro">
        <xsl:param name="organizer" />

        <xsl:for-each select="$organizer" >

            <xsl:variable name="current-organizer" select="."/>

            <xsl:for-each select="$organizer/component/observation[code/@code!='33999-4']" >

                <xsl:call-template name="make-observations-micro-row">
                    <xsl:with-param name="observation" select="."/>
                    <xsl:with-param name="organizer" select="$current-organizer"/>
                </xsl:call-template>

            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="make-observations-micro-row">
        <xsl:param name="observation"/>
        <xsl:param name="organizer"/>

        <xsl:variable name="order">
            <xsl:choose>
                <xsl:when test="$organizer/code/originalText != ''">
                    <xsl:value-of select="$organizer/code/originalText"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$organizer/code/@displayName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="order-code" select="$organizer/code/@code"/>
        <xsl:variable name="order-code-source" select="$organizer/code[0]/@codeSystem"/>
        <xsl:variable name="order-alias" select="$organizer/code/orginalText"/>

        <xsl:variable name="result" select="$observation/code/@displayName"/>
        <xsl:variable name="result-code" select="$observation/code/@code"/>
        <xsl:variable name="result-code-source" select="$observation/code[0]/@codeSystem"/>
        <xsl:variable name="status">
            <xsl:choose>
                <xsl:when test="$observation/code[@code='33999-4']/../value != ''">
                    <xsl:call-template name="get-value-display">
                        <xsl:with-param name="value-tag"
                                        select="$observation/code[@code='33999-4']/../value"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$observation/statusCode/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="ordering-provider-id">
            <xsl:value-of
                    select="$observation/participant/participantRole/playingEntity/id/@extension"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-oid">
            <xsl:value-of
                    select="$observation/participant/participantRole/playingEntity/id/@root"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-first">
            <xsl:for-each select="$observation/participant/participantRole/playingEntity/name/given">
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ordering-provider-middle">
            <xsl:for-each select="$observation/participant/participantRole/playingEntity/name/given">
                <xsl:if test="not(position()=1)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ordering-provider-last">
            <xsl:value-of
                    select="$observation/participant/participantRole/playingEntity/name/family"/>
        </xsl:variable>
        <xsl:variable name="ordering-provider-suffix">
            <xsl:value-of
                    select="$observation/participant/participantRole/playingEntity/name/suffix"/>
        </xsl:variable>


        <xsl:variable name="value_data_type" select="$observation/value/@xsi:type"/>
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="$value_data_type = 'CD'">
                    <xsl:choose>
                        <xsl:when test="$observation/value/originalText/reference/@value != ''">
                            <xsl:call-template name="get-content-display">
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id"
                                                select="translate($observation/value/originalText/reference/@value,'#','')"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$observation/value/@displayName"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$observation/value/high/@value">
                            &lt;
                            <xsl:if test="$observation/value/high/@inclusive='true'">=</xsl:if>
                            <xsl:value-of select="$observation/value/high/@value"/>
                        </xsl:when>
                        <xsl:when test="$observation/value/low/@value">
                            &gt;
                            <xsl:if test="$observation/value/low/@inclusive='true'">=</xsl:if>
                            <xsl:value-of select="$observation/value/low/@value"/>
                        </xsl:when>
                        <xsl:when test="$observation/value/@value">
                            <xsl:value-of select="$observation/value/@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$observation/value/originalText/reference/@value != ''">
                                    <xsl:call-template name="get-content-display">
                                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                        <xsl:with-param name="tag-id"
                                                        select="translate($observation/value/originalText/reference/@value,'#','')"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$observation/text/reference/@value != ''">
                                    <xsl:call-template name="get-content-display">
                                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                        <xsl:with-param name="tag-id"
                                                        select="translate($observation/text/reference/@value,'#','')"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$observation/value"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:variable name="interpretationCode">
            <xsl:value-of select="$observation/interpretationCode/@code"/>
        </xsl:variable>
        <xsl:variable name="interpretation">
            <xsl:value-of select="$observation/interpretationCode/@displayName"/>
        </xsl:variable>

        <xsl:variable name="date-results">
            <xsl:value-of select="$observation/effectiveTime/@value"/>
        </xsl:variable>

        <xsl:variable name="last-updated">
            <xsl:call-template name="get-provider-name">
                <xsl:with-param name="name-tag"
                                select="$observation/participant[@typeCode='AUTHEN']/participantRole/playingEntity/name"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="last-updated-id">
            <xsl:value-of
                    select="$observation/participant[@typeCode='AUTHEN']/participantRole/playingEntity/id/@codeSource"/>
        </xsl:variable>

        <xsl:variable name="verifier-id">
            <xsl:value-of
                    select="$observation/informant/assignedEntity/id/@extension"/>
        </xsl:variable>
        <xsl:variable name="verifier-id-oid">
            <xsl:value-of
                    select="$observation/informant/assignedEntity/id/@root"/>
        </xsl:variable>
        <xsl:variable name="verifier-first">
            <xsl:for-each select="$observation/informant/assignedEntity/assignedPerson/name/given">
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="verifier-middle">
            <xsl:for-each select="$observation/informant/assignedEntity/assignedPerson/name/given">
                <xsl:if test="not(position()=1)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="verifier-last">
            <xsl:value-of
                    select="$observation/informant/assignedEntity/assignedPerson/name/family"/>
        </xsl:variable>
        <xsl:variable name="verifier-suffix">
            <xsl:value-of
                    select="$observation/informant/assignedEntity/assignedPerson/name/suffix"/>
        </xsl:variable>

        <xsl:variable name="source">
            <xsl:call-template name="get-source-tag">
                <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                <xsl:with-param name="author-tag" select="$organizer/author"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="report-identifier">
            <!--    <xsl:choose>
                    <xsl:when test="$observation/text/reference/@value">
                        <xsl:value-of select="$observation/text/reference/@value"/>
                    </xsl:when>
                    <xsl:otherwise>-->
            <xsl:value-of select="$observation/id/@root"/>
            <!--        </xsl:otherwise>
                </xsl:choose> -->
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

        <!-- skip bad records -->
        <!--<xsl:if test="$statusUpCase != 'IN ERROR'">-->

        <!-- insert the sql here for this row. -->
        <xsl:element name="micro">
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
                <xsl:text>microbiology</xsl:text>
            </xsl:element>
            <xsl:element name="RESULT_ID">
                <xsl:value-of select="$report-identifier"/>
            </xsl:element>
            <xsl:element name="ORDER_NAME">
                <xsl:value-of select="$order"/>
            </xsl:element>
            <xsl:element name="ORDER_CODE">
                <xsl:value-of select="$order-code"/>
            </xsl:element>
            <xsl:element name="ORDER_CODE_SOURCE">
                <xsl:value-of select="$order-code-source"/>
            </xsl:element>
            <xsl:element name="ORDER_ALIAS">
                <xsl:value-of select="$order-alias"/>
            </xsl:element>
            <xsl:element name="RESULT">
                <xsl:value-of select="$result"/>
            </xsl:element>
            <xsl:element name="RESULT_CODE">
                <xsl:value-of select="$result-code"/>
            </xsl:element>
            <xsl:element name="RESULT_CODE_SOURCE">
                <xsl:value-of select="$result-code-source"/>
            </xsl:element>
            <xsl:element name="VALUE">
                <xsl:value-of select="$value"/>
            </xsl:element>
            <xsl:element name="VALUE_DATA_TYPE">
                <xsl:value-of select="$value_data_type"/>
            </xsl:element>
            <xsl:element name="INTERPRETATION">
                <xsl:value-of select="$interpretation"/>
            </xsl:element>
            <xsl:element name="INTERPRETATION_CODE">
                <xsl:value-of select="$interpretationCode"/>
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
            <xsl:element name="STATUS">
                <xsl:value-of select="$status"/>
            </xsl:element>
            <xsl:call-template name="create-comments">
                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
            <xsl:element name="RESULT_DATE">
                <xsl:value-of select="$date-results"/>
            </xsl:element>
            <xsl:element name="VERIFIER_ID">
                <xsl:value-of select="normalize-space($verifier-id)"/>
            </xsl:element>
            <xsl:element name="VERIFIER_ID_OID">
                <xsl:value-of select="normalize-space($verifier-id-oid)"/>
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
        <!--</xsl:if>-->
    </xsl:template>


</xsl:stylesheet>
