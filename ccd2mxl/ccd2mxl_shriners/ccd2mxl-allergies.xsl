<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>


    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalContentMap"/>
    <xsl:param name="globalAuthor"/>
    <xsl:param name="globalEncounterId"/>

    <xsl:template match="/">
        <xsl:for-each select="entry/act/entryRelationship/observation">
            <xsl:variable name="status">
                <xsl:choose>
                    <xsl:when test="entryRelationship/observation/code[@code='33999-4']/../value/@displayName!= ' '">
                        <xsl:value-of select="entryRelationship/observation/code[@code='33999-4']/../value/@displayName"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap" />
                            <xsl:with-param name="tag-id" select="translate(entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.28']/value/originalText/reference/@value,'#','')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="status_cd"
                          select="entryRelationship/observation/code[@code='33999-4']/../value/@code"/>

            <xsl:variable name="allergy">
                <xsl:choose>
                    <xsl:when test="participant[1]/participantRole/playingEntity/code/originalText/reference/@value != ''">
                        <xsl:call-template name="get-content-display" >
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id" select="translate(participant[1]/participantRole/playingEntity/code/originalText/reference/@value,'#','')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-code-display" >
                            <xsl:with-param name="code-tag" select="participant[1]/participantRole/playingEntity/code" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="allergy-code">
                <xsl:choose>
                    <xsl:when test="participant[1]/participantRole/playingEntity/code/@code != '' and participant[1]/participantRole/playingEntity/code/@code != '0'">
                        <xsl:value-of select="participant[1]/participantRole/playingEntity/code/@code" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="participant[1]/participantRole/playingEntity/code/@displayName" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="allergy-code-source"
                          select="normalize-space(participant[1]/participantRole/playingEntity/code/@codeSystem)"/>
            <xsl:variable name="reactions">

                <xsl:for-each select="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.54' or @root='2.16.840.1.113883.10.20.22.4.9']/../.">
                    <xsl:if test="position() > 1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="value/@displayName != ''">
                            <xsl:value-of select="value/@displayName" />
                        </xsl:when>
                        <xsl:when test="text/reference/@value != ''">
                            <xsl:call-template name="get-content-display" >
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id" select="translate(text/reference/@value,'#','')" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="text" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="reactions_cd">
                <xsl:value-of select="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.54' or @root='2.16.840.1.113883.10.20.22.4.9']/../value/@code" />
            </xsl:variable>
            <xsl:variable name="severity">
                <xsl:choose>
                    <xsl:when test="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/value/originalText/reference/@value!=''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap" />
                            <xsl:with-param name="tag-id" select="translate(entryRelationship/observation[(templateId/@root='2.16.840.1.113883.10.20.22.4.8') or (templateId/@root='2.16.840.1.113883.10.20.22.4.7')]/value/originalText/reference/@value,'#','')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/text/reference/@value!=''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap" />
                            <xsl:with-param name="tag-id" select="translate(entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/text/reference/@value,'#','')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/value/@displayName != ''">
                        <xsl:value-of select="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/value/@displayName"/>
                    </xsl:when>
                    <xsl:when test="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.55']/../value/@displayName != ''">
                        <xsl:value-of select="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.55']/../value/@displayName" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.55']/../text" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="severity_cd">
                <xsl:choose>
                    <xsl:when test="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/value/@code != ''">
                        <xsl:value-of select="entryRelationship/observation[templateId/@root='2.16.840.1.113883.10.20.22.4.8']/value/@code"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="entryRelationship/observation/templateId[@root='2.16.840.1.113883.10.20.1.55']/../value/@code" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="reaction-type"
                          select="normalize-space(value/@displayName)"/>

            <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

            <xsl:variable name="temp_date_reported">
                <xsl:call-template name="format-date-node">
                    <xsl:with-param name="date-node" select="effectiveTime" />
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="date_reported">
                <xsl:choose>
                    <xsl:when test="$temp_date_reported != ''"><xsl:value-of select="$temp_date_reported"/></xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="format-date-node">
                            <xsl:with-param name="date-node" select="../../effectiveTime" />
                        </xsl:call-template>
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

            <!-- record only current records -->
            <!-- leave it up to the view what status to show <xsl:if test="$statusUpCase = 'ACTIVE'">-->

            <!-- insert the SQL here for this row. -->
            <xsl:if test="$allergy!=''">
                <xsl:element name="allergy">
                    <xsl:element name="SOURCE">
                        <xsl:call-template name="get-source-tag">
                            <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                            <xsl:with-param name="author-tag" select="./author"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="ENCOUNTER_NUM">
                        <xsl:value-of select="$encounter-number"/>
                    </xsl:element>
                    <xsl:element name="ENCOUNTER_ORIGIN">
                        <xsl:value-of select="$resolvedEncounterOrigin"/>
                    </xsl:element>
                    <xsl:element name="DOCUMENT_DATETIME">
                        <xsl:call-template name="format-date-node">
                            <xsl:with-param name="date-node" select="../../effectiveTime" />
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="ALLERGY">
                        <xsl:value-of select="$allergy"/>
                    </xsl:element>
                    <xsl:element name="ALLERGY_CODE">
                        <xsl:value-of select="$allergy-code"/>
                    </xsl:element>
                    <xsl:element name="ALLERGY_CODE_SOURCE">
                        <xsl:value-of select="$allergy-code-source"/>
                    </xsl:element>
                    <xsl:element name="ALLERGY_TYPE_CODE">
                        <xsl:value-of select="normalize-space(value/@code)"/>
                    </xsl:element>
                    <xsl:element name="ALLERGY_TYPE_DISP">
                        <xsl:value-of select="normalize-space(value/@displayName)"/>
                    </xsl:element>
                    <xsl:element name="CATEGORY">
                        <xsl:value-of select="normalize-space(code/@displayName)"/>
                    </xsl:element>
                    <xsl:element name="CATEGORY_CODE">
                        <xsl:value-of select="normalize-space(code/@code)"/>
                    </xsl:element>
                    <xsl:element name="REACTIONS">
                        <xsl:value-of select="$reactions"/>
                    </xsl:element>
                    <xsl:element name="REACTIONS_CODE">
                        <xsl:value-of select="$reactions_cd"/>
                    </xsl:element>
                    <xsl:element name="DATE_REPORTED">
                        <xsl:value-of select="$date_reported"/>
                    </xsl:element>
                    <xsl:element name="SEVERITY">
                        <xsl:value-of select="$severity"/>
                    </xsl:element>
                    <xsl:element name="SEVERITY_CODE">
                        <xsl:value-of select="$severity_cd"/>
                    </xsl:element>
                    <xsl:element name="REACTION_TYPE">
                        <xsl:value-of select="normalize-space($reaction-type)"/>
                    </xsl:element>
                    <xsl:element name="STATUS">
                        <xsl:value-of select="normalize-space($status)"/>
                    </xsl:element>
                    <xsl:element name="STATUS_CODE">
                        <xsl:value-of select="normalize-space($status_cd)"/>
                    </xsl:element>
                    <xsl:call-template name="create-comments">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                    <!-- TODO - LAST_REVIEWED_BY needs to be updated when it is supplied -->

                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>