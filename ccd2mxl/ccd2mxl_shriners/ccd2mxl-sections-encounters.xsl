<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>
    <xsl:import href="ccd2mxl-sections-problems.xsl"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalAssigningAuthorityName"/>

    <xsl:template match="/">

            <xsl:if test="encounter/entryRelationship/act/entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.1.28' or templateId/@root='2.16.840.1.113883.10.20.22.4.4'] !=''">
                <xsl:variable name="diagnosis">
                    <entry>
                        <xsl:copy-of select="encounter/entryRelationship/act"/>
                    </entry>
                </xsl:variable>
                <xsl:call-template name="build-section-problems">
                    <xsl:with-param name="section" select="$diagnosis"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:variable name="location">
                <xsl:choose>
                    <xsl:when test="encounter/participant/participantRole/addr[unitType='FACILITY']/unitID != ''">
                        <xsl:value-of
                                select="encounter/participant/participantRole/addr[unitType='FACILITY']/unitID"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                                select="encounter/participant/participantRole/playingEntity/name"/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:variable>

            <xsl:variable name="location-details">
                <xsl:value-of
                        select="encounter/participant/participantRole/addr[unitType='BLDG']/unitID"/>
            </xsl:variable>

            <xsl:variable name="encounter-type">
                <xsl:choose>
                    <xsl:when test="translate(encounter/code/originalText/reference/@value,'#','') != ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(encounter/code/originalText/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="encounter/code/originalText != ''">
                        <xsl:value-of
                                select="encounter/code/originalText"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                                select="encounter/entryRelationship/observation[code/@code='ENCOUNTERTYPE']/value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="encounter-number">
                <xsl:choose>
                    <xsl:when test="$globalAssigningAuthorityName = 'eClinicalWorks'">
                        <xsl:value-of select="globalAssigningAuthorityName"/>
                    </xsl:when>
                    <xsl:when test="encounter/id/@extension">
                        <xsl:value-of select="encounter/id/@extension"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="encounter/id/@root"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

        <xsl:variable name="reason-for-visit-temp">
            <xsl:choose>
                <xsl:when test="translate(encounter/entryRelationship/observation/value/originalText/reference/@value,'#','') !=''">
                    <xsl:call-template name="get-content-display">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"
                                        select="translate(encounter/entryRelationship/observation/value/originalText/reference/@value,'#','')"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="reason-for-visit">
            <xsl:choose>
                <xsl:when test="encounter/entryRelationship/observation[code/@code='ASSERTION']/value!=''">
                    <xsl:value-of
                            select="encounter/entryRelationship/observation[code/@code='ASSERTION']/value"/>
                </xsl:when>
                <xsl:when test="encounter/entryRelationship/observation/value/@displayName!=''">
                    <xsl:value-of select="encounter/entryRelationship/observation/value/@displayName"/>
                </xsl:when>
                <xsl:when test="reason-for-visit-temp!=''">
                    <xsl:value-of select="$reason-for-visit-temp"/>
                </xsl:when>
                <xsl:when test="encounter/entryRelationship/observation/value/originalText/reference/@value !=''"> <!--if reason-for-visit-temp not set, then set this to ref id for the resolver -->
                    <xsl:text>_MAPID:</xsl:text><xsl:value-of select="translate(encounter/entryRelationship/observation/value/originalText/reference/@value,'#','')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

            <xsl:variable name="attending-provider">
                <xsl:call-template name="get-provider-name">
                    <xsl:with-param name="name-tag"
                                    select="encounter/performer[@typeCode='PRF']/assignedEntity/assignedPerson/name"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="attending-provider-id">
                <xsl:value-of
                        select="encounter/performer[1]/assignedEntity/id/@extension"/>
            </xsl:variable>
            <xsl:variable name="attending-provider-oid">
                <xsl:value-of
                        select="encounter/performer[1]/assignedEntity/id/@root"/>
            </xsl:variable>
            <xsl:variable name="attending-provider-first">
                <xsl:for-each select="encounter/performer[1]/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="position()=1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="attending-provider-middle">
                <xsl:for-each select="encounter/performer[1]/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="not(position()=1)">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="attending-provider-last">
                <xsl:value-of
                        select="encounter/performer[1]/assignedEntity/assignedPerson/name/family"/>
            </xsl:variable>
            <xsl:variable name="attending-provider-suffix">
                <xsl:value-of
                        select="encounter/performer[1]/assignedEntity/assignedPerson/name/suffix"/>
            </xsl:variable>

            <xsl:variable name="status">
                <xsl:value-of
                        select="encounter/entryRelationship/observation[code/@code='STATUS']/value"/>
            </xsl:variable>

            <xsl:variable name="source">
                <xsl:call-template name="get-source-tag">
                    <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                    <xsl:with-param name="author-tag" select="encounter/author"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="admit_date">
                <xsl:choose>
                    <xsl:when test="encounter/effectiveTime/low/@value != ''">
                        <xsl:value-of select="encounter/effectiveTime/low/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="encounter/effectiveTime/@value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="source_display">
                <xsl:call-template name="translate-source">
                    <xsl:with-param name="id-tag" select="$source"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="discharge_date">
                <xsl:choose>
                    <xsl:when test="encounter/effectiveTime/high/@value != ''">
                        <xsl:value-of select="encounter/effectiveTime/high/@value"/>
                    </xsl:when>
                    <xsl:when test="$source_display='MHHS'">
                        <xsl:value-of select="$admit_date"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <!-- insert the SQL here for this row. -->
            <xsl:element name="encounter">
                <xsl:element name="SOURCE">
                    <xsl:value-of select="$source"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_NUM">
                    <xsl:value-of select="$resolvedEncounterId"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_ORIGIN">
                    <xsl:value-of select="$resolvedEncounterOrigin"/>
                </xsl:element>
                <xsl:element name="DOCUMENT_DATETIME">
                    <xsl:value-of select="$globalDocumentTs"/>
                </xsl:element>
                <xsl:element name="FACILITY">
                    <xsl:value-of select="$location"/>
                </xsl:element>
                <xsl:element name="BUILDING">
                    <xsl:value-of select="$location-details"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_TYPE">
                    <xsl:value-of select="$encounter-type"/>
                </xsl:element>
                <xsl:element name="ENCOUNTER_NUMBER">
                    <xsl:value-of select="$encounter-number"/>
                </xsl:element>
                <xsl:element name="REASON">
                    <xsl:value-of select="$reason-for-visit"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_ID">
                    <xsl:value-of select="normalize-space($attending-provider-id)"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_ID_OID">
                    <xsl:value-of select="normalize-space($attending-provider-oid)"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_FIRST">
                    <xsl:value-of select="normalize-space($attending-provider-first)"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_MIDDLE">
                    <xsl:value-of select="normalize-space($attending-provider-middle)"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_LAST">
                    <xsl:value-of select="normalize-space($attending-provider-last)"/>
                </xsl:element>
                <xsl:element name="ATTENDING_PROVIDER_SUFFIX">
                    <xsl:value-of select="normalize-space($attending-provider-suffix)"/>
                </xsl:element>
                <xsl:element name="ADMIT_DATE">
                    <xsl:value-of select="$admit_date"/>
                </xsl:element>
                <xsl:element name="DISCHARGE_DATE">
                    <xsl:value-of select="$discharge_date"/>
                </xsl:element>
                <xsl:element name="STATUS">
                    <xsl:value-of select="$status"/>
                </xsl:element>
            </xsl:element>
    </xsl:template>

    <xsl:template name="translate-source">
        <xsl:param name="id-tag"/>
        <xsl:choose>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.0.100'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.1'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.3'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.4'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.5'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.6'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.7'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.8'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.9'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.615.10'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.4.391.11.6779'">
                <xsl:text>MHHS</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$id-tag"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
