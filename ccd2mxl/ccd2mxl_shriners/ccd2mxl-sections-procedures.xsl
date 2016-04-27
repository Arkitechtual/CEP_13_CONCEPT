<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalEncounterId"/>


    <xsl:template match="/">

        <xsl:for-each select="entry">

            <xsl:variable name="procedure">
                <xsl:choose>
                    <xsl:when test="./procedure/code/originalText/reference/@value != ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./procedure/code/originalText/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="./procedure/text/reference/@value != ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id" select="translate(./procedure/text/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                            test="./procedure/value/originalText/reference/@value != '' and ./procedure/text/reference/@value = ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./procedure/value/originalText/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-code-display">
                            <xsl:with-param name="code-tag" select="./procedure/code"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="procedure_code">
                <xsl:choose>
                    <xsl:when test="./procedure/code/@code = 'OTH' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/translation/@code"/>
                    </xsl:when>
                    <xsl:when test="./procedure/code/@nullFlavor='UNK' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/translation/@code"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./procedure/code/@code"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="procedure_source">
                <xsl:choose>
                    <xsl:when test="./procedure/code/@code = 'OTH' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/translation/@codeSystem"/>
                    </xsl:when>
                    <xsl:when test="./procedure/code/@nullFlavor='UNK' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/translation/@codeSystem"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./procedure/code/@codeSystem"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="procedure_source_name">
                <xsl:choose>
                    <xsl:when test="./procedure/code/@code = 'OTH' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/@codeSystemName"/>
                    </xsl:when>
                    <xsl:when test="./procedure/code/@nullFlavor='UNK' and ./procedure/code/translation/@code != ''">
                        <xsl:value-of select="./procedure/code/translation/@codeSystemName"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./procedure/code/@codeSystemName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="procedure_date">
                <xsl:call-template name="format-date-node">
                    <xsl:with-param name="date-node" select="procedure/effectiveTime"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="surgeon">
                <xsl:value-of
                        select="./procedure/performer/assignedEntity/assignedPerson/name/family"/>
                <xsl:if test="./procedure/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:text></xsl:text>
                    ,
                    <xsl:for-each
                            select="./procedure/performer/assignedEntity/assignedPerson/name/given">
                        <xsl:value-of select="."/>
                        <xsl:text></xsl:text>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="./procedure/performer/assignedEntity/assignedPerson/name/suffix">
                    <xsl:text></xsl:text>
                    <xsl:value-of
                            select="./procedure/performer/assignedEntity/assignedPerson/name/suffix"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="surgeon-id">
                <xsl:value-of
                        select="./procedure/performer/assignedEntity/id/@extension"/>
            </xsl:variable>
            <xsl:variable name="surgeon-oid">
                <xsl:value-of
                        select="./procedure/performer/assignedEntity/id/@root"/>
            </xsl:variable>
            <xsl:variable name="surgeon-first">
                <xsl:for-each select="./procedure/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="position()=1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="surgeon-middle">
                <xsl:for-each select="./procedure/performer/assignedEntity/assignedPerson/name/given">
                    <xsl:if test="not(position()=1)">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="surgeon-last">
                <xsl:value-of
                        select="./procedure/performer/assignedEntity/assignedPerson/name/family"/>
            </xsl:variable>
            <xsl:variable name="surgeon-suffix">
                <xsl:value-of
                        select="./procedure/performer/assignedEntity/assignedPerson/name/suffix"/>
            </xsl:variable>

            <xsl:variable name="comments">
                <xsl:for-each select="./procedure/entryRelationship/act[code/@code='48767-8']">
                    <xsl:choose>
                        <xsl:when test="./text/reference/@value != ''">
                            <xsl:call-template name="get-content-display">
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id" select="translate(./text/reference/@value,'#','')"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./text"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="fn:position() != last()">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>

            <xsl:variable name="source">
                <xsl:call-template name="get-source-tag">
                    <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                    <xsl:with-param name="author-tag" select="./procedure/author"/>
                </xsl:call-template>
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

            <xsl:if test="$procedure!=''">
                <xsl:element name="procedure">
                    <xsl:element name="SOURCE">
                        <xsl:value-of select="$source"/>
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
                    <xsl:element name="PROCEDURE">
                        <xsl:value-of select="normalize-space($procedure)"/>
                    </xsl:element>
                    <xsl:element name="PROCEDURE_CODE">
                        <xsl:value-of select="$procedure_code"/>
                    </xsl:element>
                    <xsl:element name="PROCEDURE_CODE_SOURCE">
                        <xsl:value-of select="normalize-space($procedure_source)"/>
                    </xsl:element>
                    <xsl:element name="PROCEDURE_CODE_SOURCE_NAME">
                        <xsl:value-of select="normalize-space($procedure_source_name)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_ID">
                        <xsl:value-of select="normalize-space($surgeon-id)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_ID_OID">
                        <xsl:value-of select="normalize-space($surgeon-oid)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_FIRST">
                        <xsl:value-of select="normalize-space($surgeon-first)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_MIDDLE">
                        <xsl:value-of select="normalize-space($surgeon-middle)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_LAST">
                        <xsl:value-of select="normalize-space($surgeon-last)"/>
                    </xsl:element>
                    <xsl:element name="SURGEON_SUFFIX">
                        <xsl:value-of select="normalize-space($surgeon-suffix)"/>
                    </xsl:element>
                    <xsl:element name="PROCEDURE_DATETIME">
                        <xsl:value-of select="$procedure_date"/>
                    </xsl:element>
                    <xsl:element name="COMMENTS">
                        <xsl:value-of select="normalize-space($comments)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>