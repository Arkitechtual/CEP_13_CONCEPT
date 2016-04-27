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

    <xsl:template name="build-section-problems" match="/">
        <xsl:param name="section"/>
        <xsl:variable name="data_node">
            <xsl:choose>
                <xsl:when test="$section != ''"><xsl:copy-of select="$section"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:for-each select="$data_node/entry/act/entryRelationship/observation[(templateId/@root='2.16.840.1.113883.10.20.1.28')or (templateId/@root='2.16.840.1.113883.10.20.22.4.4')]"> <!--Mod:0001-->
            <xsl:variable name="problem">
                <xsl:choose>
                    <xsl:when
                            test="./value/originalText/reference/@value != '' ">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./value/originalText/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                            test="./text/reference/@value != ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./text/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-value-display">
                            <xsl:with-param name="value-tag"
                                            select="./value"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="problem_code">
                <xsl:choose>
                    <xsl:when test="./value/@code = 'OTH' and ./value/translation[1]/@code != ''">
                        <xsl:value-of select="./value/translation[1]/@code" />
                    </xsl:when>
                    <xsl:when
                            test="(./value/@nullFlavor != '')  and ./value/translation[1]/@code != ''">
                        <xsl:value-of
                                select="./value/translation[1]/@code"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                                select="./value/@code"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="problem_source_system">
                <xsl:choose>
                    <xsl:when test="./value/@codeSystem = '' and ./value/translation[1]/@code != ''">
                        <xsl:value-of
                                select="normalize-space(./value/translation[1]/@codeSystem)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                                select="normalize-space(./value/@codeSystem)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="problem_source">
                <xsl:choose>
                    <xsl:when
                            test="./value/@code = 'OTH' and ./value/translation[1]/@code != ''">
                        <xsl:value-of
                                select="./value/translation[1]/@codeSystemName"/>
                    </xsl:when>
                    <xsl:when
                            test="(./value/@nullFlavor != '') and ./value/translation[1]/@code != ''">
                        <xsl:value-of
                                select="./value/translation[1]/@codeSystemName"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                                select="./value/@codeSystemName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="status_cd">
                <xsl:value-of
                        select="./entryRelationship/observation/code[@code='33999-4']/../value/@code"/>
            </xsl:variable>

            <xsl:variable name="status">
                <xsl:choose>
                    <xsl:when test="$status_cd='55561003'">
                        <xsl:text>Active</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='73425007'">
                        <xsl:text>Inactive</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='90734009'">
                        <xsl:text>Chronic</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='7087005'">
                        <xsl:text>Intermittent</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='255227004'">
                        <xsl:text>Recurrent</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='415684004'">
                        <xsl:text>Rule out</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='410516002'">
                        <xsl:text>Ruled out</xsl:text>
                    </xsl:when>
                    <xsl:when test="$status_cd='413322009'">
                        <xsl:text>Resolved</xsl:text>
                    </xsl:when>
                    <xsl:when
                            test="./entryRelationship/observation/code[@code='33999-4']/../text/reference/@value != ''">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="tag-id"
                                            select="translate(./entryRelationship/observation/code[@code='33999-4']/../text/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-value-display">
                            <xsl:with-param name="value-tag"
                                            select="./entryRelationship/observation/code[@code='33999-4']/../value"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="onset-date">
                <xsl:call-template name="format-date-node">
                    <xsl:with-param name="date-node"
                                    select="./effectiveTime"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="classification"><!-- get the value of the classification observation -->
                <xsl:call-template name="get-value-display">
                    <xsl:with-param name="value-tag"
                                    select="./entryRelationship/observation/code[@code='415039016']/../value"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="classification_cd"><!-- get the value of the classification observation -->
                <xsl:value-of
                        select="./entryRelationship/observation/code[@code='415039016']/../value/@code"/>
            </xsl:variable>

            <xsl:variable name="verified">
                <xsl:value-of select="$globalDocumentTs"/>
            </xsl:variable>

            <!--<xsl:variable name="provider"> DON'T FILL THIS OUT AS THE DATA IS NOT SENT IN HL7. DON'T USE FROM ENCOUNTER
                     <xsl:call-template name="get-provider-name" >
                         <xsl:with-param name="name-tag" select="/root/ClinicalDocument[1]/component/structuredBody/component/section/entry[@typeCode='DRIV']/encounter/performer/assignedEntity/assignedPerson/name" />
                     </xsl:call-template>
                 </xsl:variable>	-->

            <xsl:variable name="source">
                <xsl:call-template name="get-source-tag">
                    <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                    <xsl:with-param name="author-tag" select="./../../author"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="problem_type_cd">
                <xsl:choose>
                    <xsl:when
                            test="./code/@code='282291009' or ./code/@code='89100005'">
                        <xsl:text>Diagnosis</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Condition</xsl:text>
                    </xsl:otherwise>
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
            <!-- Record only current records -->
            <!-- leave it up to the view what status to show <xsl:if test="$statusUpCase = 'ACTIVE'">-->
            <!--
            insert the sql here for this row.
            ASSUMPTIONS: effectiveTime at the top level (act) is the onset date - CHECK
            -->
            <xsl:if test="$problem!=''">
                <xsl:element name="problem">
                    <xsl:element name="SUB_TYPE">
                        <xsl:value-of select="$problem_type_cd"/>
                    </xsl:element>
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
                    <xsl:element name="PROBLEM">
                        <xsl:value-of select="normalize-space($problem)"/>
                    </xsl:element>
                    <xsl:element name="PROBLEM_SOURCE">
                        <xsl:value-of
                                select="$problem_code"/>
                    </xsl:element>
                    <xsl:element name="PROBLEM_CODE_SYSTEM">
                        <xsl:value-of
                                select="$problem_source_system"/>
                    </xsl:element>
                    <xsl:element name="PROBLEM_CODE_NAME">
                        <xsl:value-of
                                select="$problem_source"/>
                    </xsl:element>
                    <xsl:element name="PROBLEM_TYPE_CODE">
                        <xsl:value-of
                                select="normalize-space(./code/@code)"/>
                    </xsl:element>
                    <xsl:element name="PROBLEM_TYPE_CODE_DISP">
                        <xsl:value-of
                                select="normalize-space(./code/@displayName)"/>
                    </xsl:element>
                    <xsl:element name="STATUS">
                        <xsl:value-of select="normalize-space($status)"/>
                    </xsl:element>
                    <xsl:element name="STATUS_CODE">
                        <xsl:value-of select="normalize-space($status_cd)"/>
                    </xsl:element>
                    <xsl:element name="ONSET_DATE">
                        <xsl:value-of select="$onset-date"/>
                    </xsl:element>
                    <xsl:element name="ACTION_DATE">
                        <xsl:value-of select="$verified"/>
                    </xsl:element>
                    <xsl:element name="CLASSIFICATION">
                        <xsl:value-of select="normalize-space($classification)"/>
                    </xsl:element>
                    <xsl:call-template name="create-comments">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="node" select="./../../entryRelationship/observation"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
