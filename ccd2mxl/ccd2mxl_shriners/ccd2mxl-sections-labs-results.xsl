<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:util="http://www.browsersoft.com/">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalAuthor"/>

    <xsl:param name="globalOrganizerId"/>
    <xsl:param name="globalOrganizerDisplayName"/>
    <xsl:param name="globalOrganizerCode"/>
    <xsl:param name="globalOrganizerCodeSystem"/>
    <xsl:param name="globalOrganizerOriginalText"/>
    <xsl:param name="globalOrganizerIdOriginalText"/>
    <xsl:param name="globalObservationCount"/>
    <xsl:param name="globalEncounterId"/>

    <!--    <xsl:template match="/"> -->
    <xsl:template name="build-section-labs-results">
        <xsl:param name="organizer"/>

        <xsl:variable name="order-name">
            <xsl:choose>
                <xsl:when test="$organizer/code/originalText != ''">
                    <xsl:value-of select="$organizer/code/originalText"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$organizer/code/@displayName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="encounter_num"
                      select="normalize-space($organizer/component/encounter/id/@extension)"/>

        <xsl:for-each select="$organizer/component/observation">

            <xsl:call-template name="make-observations-row" >
                <xsl:with-param name="organizer" select="$organizer" />
                <xsl:with-param name="order-name" select="$order-name" />
                <xsl:with-param name="observation" select="." />
                <xsl:with-param name="count" select="position()"/>
                <xsl:with-param name="encounter_num" select="$encounter_num" />
            </xsl:call-template>
        </xsl:for-each>


    </xsl:template>

    <xsl:template name="make-observations-row" >
        <xsl:param name="organizer" />
        <xsl:param name="observation"/>
        <xsl:param name="order-name"/>
        <xsl:param name="count"/>
        <xsl:param name="encounter_num"/>

        <xsl:variable name="order-provider-firstName" select="$observation/informant/assignedEntity/assignedPerson/name/given[1]"/>
        <xsl:variable name="order-provider-lastName" select="$observation/informant/assignedEntity/assignedPerson/name/family"/>
        <xsl:variable name="order-code">
            <xsl:choose>
                <xsl:when test="$organizer/code/@code != ''">
                    <xsl:value-of select="$organizer/code/@code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$order-name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="order-code-source" select="$organizer/code/@codeSystem"/>
        <xsl:variable name="order-alias" select="$order-name"/>

        <xsl:variable name="result_disp">
            <xsl:if test="$observation/text/reference/@value !='' and $observation/text/reference/@value !='UNK'">
                <xsl:call-template name="get-content-display">
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                    <xsl:with-param name="tag-id"
                                    select="translate($observation/text/reference/@value,'#','')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>


        <xsl:variable name="result">
            <xsl:choose>
                <!-- Workround for Meditech 5.x CCD. They don't have any reference to the result name in the structured <entry> -->
                <xsl:when test="contains($globalAuthor,'Upson Regional') and $observation/text/reference/@value != ''">
                    <xsl:call-template name="get-content-display">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"
                                        select="translate($observation/text/reference/@value,'#value','result')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="normalize-space($observation/code/originalText) !=''">
                    <xsl:value-of select="$observation/code/originalText" />
                </xsl:when>
                <xsl:when test="$observation/code/@displayName !='' and $observation/code/@displayName != 'Laboratory Results'">
                    <xsl:value-of select="$observation/code/@displayName"/>
                </xsl:when>
                <!-- <xsl:otherwise>
     <xsl:call-template name="get-content-display">
      <xsl:with-param name="contentMap" select="$globalContentMap"/>
      <xsl:with-param name="tag-id"
          select="translate($observation/code/originalText/reference/@value,'#','')"/>
     </xsl:call-template>
     </xsl:otherwise> -->
                <xsl:when test="$observation/code/@nullFlavor='UNK'">
                    <xsl:choose>
                        <xsl:when test="$observation/code/originalText!=''">
                            <xsl:value-of select="$observation/code/originalText"/>
                        </xsl:when>
                        <xsl:when test="$observation/code/originalText/reference/@value!=''">
                            <xsl:call-template name="get-content-display" >
                                <xsl:with-param name="contentMap" select="$globalContentMap" />
                                <xsl:with-param name="tag-id" select="translate($observation/code/originalText/reference/@value,'#','')" />
                            </xsl:call-template>
                        </xsl:when>
                        <!-- <xsl:when test="$globalOrganizerDisplayName!=''">
                            <xsl:value-of select="$globalOrganizerDisplayName"/>
                        </xsl:when> -->
                        <!-- Meditech CCDs put the Result name here for some reason... -->
                        <xsl:when test="$observation/text != ''">
                            <xsl:value-of select="$observation/text" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$result_disp" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="result-code" select="$observation/code/@code"/>
        <xsl:variable name="result-code-source" select="$observation/code[0]/@codeSystem"/>
        <xsl:variable name="result_id">
            <xsl:choose>
                <xsl:when test="$observation/text/reference/@value !=''">
                    <xsl:value-of select="$observation/text/reference/@value"/>
                </xsl:when>
                <xsl:when test="$organizer/text/reference/@value !=''">
                    <xsl:value-of select="../procedure/text/reference/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$result-code"/>
                    <xsl:value-of select="$result"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="result-ibox-text">
            <xsl:call-template name="get-iboxtext-display">
                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                <xsl:with-param name="tag-id" select="translate($result_id,'#','')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="result-ibox-text-caption">
            <xsl:call-template name="get-iboxtext-caption">
                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                <xsl:with-param name="tag-id" select="translate($result_id,'#','')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="status" select="$observation/statusCode/@code"/>

        <xsl:variable name="reference_value">
            <xsl:if test="$observation/value/originalText/reference/@value != ''">
                <xsl:call-template name="get-content-display">
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                    <xsl:with-param name="tag-id"
                                    select="translate($observation/value/originalText/reference/@value,'#','')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="value_data_type" select="$observation/value/@xsi:type"/>
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="$value_data_type = 'CD' or $value_data_type = 'CE'">
                    <xsl:choose>
                        <xsl:when test="normalize-space($reference_value) != ''">
                            <xsl:value-of select="normalize-space($reference_value)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$observation/value/@displayName"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$value_data_type = 'ST'">
                    <xsl:choose>
                        <xsl:when test="normalize-space($reference_value) != ''">
                            <xsl:call-template name="get-content-display">
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id"
                                                select="translate($observation/value/originalText/reference/@value,'#','')"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="normalize-space($observation/value) != ''">
                            <xsl:value-of select="$observation/value"/>
                        </xsl:when>
                        <xsl:when test="normalize-space($observation/text/reference/@value) != ''">
                            <xsl:call-template name="get-content-display">
                                <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                <xsl:with-param name="tag-id"
                                                select="translate($observation/text/reference/@value,'#','')"/>
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
                            <xsl:text>&lt;</xsl:text>
                            <xsl:if test="$observation/value/high/@inclusive='true'">=</xsl:if>
                            <xsl:value-of select="$observation/value/high/@value"/>
                        </xsl:when>
                        <xsl:when test="$observation/value/low/@value">
                            <xsl:text>&gt;</xsl:text>
                            <xsl:if test="$observation/value/low/@inclusive='true'">=</xsl:if>
                            <xsl:value-of select="$observation/value/low/@value"/>
                        </xsl:when>
                        <!-- <xsl:when test="$observation/value/@value"> -->
                        <xsl:when test="($observation/value/@value) and not($observation/value/reference/@value)">
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
                                <xsl:otherwise>
                                    <xsl:value-of select="$observation/value"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:variable name="value_unit">
            <xsl:choose>
                <xsl:when test="$observation/value/high/@value">
                    <xsl:call-template name="get-value-units">
                        <xsl:with-param name="valueRef" select="$observation/value/high"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$observation/value/low/@value">
                    <xsl:call-template name="get-value-units">
                        <xsl:with-param name="valueRef" select="$observation/value/low"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="get-value-units">
                        <xsl:with-param name="valueRef" select="$observation/value"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="value_translation_unit">
            <xsl:if test="$observation/value/translation/originalText != ''">
                <xsl:value-of select="$observation/value/@unit"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="interpretationCode">
            <xsl:choose>
                <xsl:when
                        test="$observation/interpretationCode/@code != '' and $observation/interpretationCode/@code = 'OTH'">
                    <xsl:value-of select="translate($observation/interpretationCode/@displayName,' ','')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$observation/interpretationCode/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="interpretation">
            <xsl:value-of select="$observation/interpretationCode/@displayName"/>
        </xsl:variable>

        <!-- This checks to see if it's a order in our view based on the presence of the procedure tag -->
        <xsl:variable name="procedurePresent">
            <xsl:choose>
                <xsl:when test="$organizer/../procedure/text/reference/@value !=''">
                    <xsl:text>Yes</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="date-results">
            <xsl:choose>
                <xsl:when test="$observation/effectiveTime/@value">
                    <xsl:value-of select="$observation/effectiveTime/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$observation/performer/time/low/@value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="updated-id">
            <xsl:value-of
                    select="$observation/performer/assignedEntity/id/@extension"/>
        </xsl:variable>
        <xsl:variable name="updated-id-oid">
            <xsl:value-of
                    select="$observation/performer/assignedEntity/id/@root"/>
        </xsl:variable>
        <xsl:variable name="updated-first">
            <xsl:for-each select="$observation/performer/assignedEntity/assignedPerson/name/given">
                <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="updated-middle">
            <xsl:for-each select="$observation/performer/assignedEntity/assignedPerson/name/given">
                <xsl:if test="not(position()=1)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="updated-last">
            <xsl:value-of
                    select="$observation/performer/assignedEntity/assignedPerson/name/family"/>
        </xsl:variable>
        <xsl:variable name="updated-suffix">
            <xsl:value-of
                    select="$observation/performer/assignedEntity/assignedPerson/name/suffix"/>
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

        <xsl:variable name="source-results">
            <xsl:call-template name="get-source-tag">
                <xsl:with-param name="globalAuthor" select="$globalAuthor"/>
                <xsl:with-param name="author-tag" select="$organizer/author"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:variable name="report-text">
            <xsl:choose>
                <xsl:when test="contains($source-results,'1.3.6.1.4.1.22812.4.73547.0') and observation/entryRelationship/act/text/reference/@value !=''">
                    <xsl:call-template name="get-content-display" >
                        <xsl:with-param name="contentMap" select="$globalContentMap" />
                        <xsl:with-param name="tag-id" select="translate($observation/entryRelationship/act/text/reference/@value,'#','')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$observation/text/reference/@value !=''">
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
        </xsl:variable>

        <xsl:variable name="lab-result-year" select="substring($observation/effectiveTime/@value,0,5)"/>
        <xsl:variable name="lab-result-month" select="substring($observation/effectiveTime/@value,5,2)"/>

        <xsl:variable name="current-year" select="fn:year-from-date(current-date())"/>
        <xsl:variable name="current-month" select="fn:month-from-date(current-date())"/>

        <xsl:variable name="months-between">
            <xsl:call-template name="get-months-between">
                <xsl:with-param name="labyear" select="$lab-result-year"/>
                <xsl:with-param name="labmonth" select="$lab-result-month"/>
                <xsl:with-param name="currentyear" select="$current-year"/>
                <xsl:with-param name="currentmonth" select="$current-month"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:variable name="range">
            <xsl:choose>
                <xsl:when test="$observation/referenceRange/observationRange/text/reference/@value != ''">
                    <xsl:call-template name="get-content-display">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id"
                                        select="translate($observation/referenceRange/observationRange/text/reference/@value,'#','')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$observation/referenceRange/observationRange/text != ''">
                    <xsl:value-of select="normalize-space($observation/referenceRange/observationRange/text)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($observation/referenceRange/observationRange)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="low-value-from-range">
            <xsl:choose>
                <xsl:when test="contains($range,'-')"><xsl:value-of select="normalize-space(tokenize($range,'-')[1])"/></xsl:when>
                <xsl:when test="contains($range,'&amp;gt;')"><xsl:text>&gt;</xsl:text><xsl:value-of select="translate(normalize-space(tokenize($range,'&amp;gt;')[2]),translate(normalize-space(tokenize($range,'&amp;gt;')[2]),'=0123456789.', ''),'')"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="high-value-from-range">
            <xsl:choose>
                <xsl:when test="contains($range,'-')"><xsl:value-of select="normalize-space(tokenize($range,'-')[2])"/></xsl:when>
                <xsl:when test="contains($range,'&amp;lt;')"><xsl:text>&lt;</xsl:text><xsl:value-of select="translate(normalize-space(tokenize($range,'&amp;lt;')[2]),translate(normalize-space(tokenize($range,'&amp;lt;')[2]),'=0123456789.', ''),'')"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="low-value">
            <xsl:choose>
                <xsl:when test="$observation/referenceRange/observationRange/value/low/@value">
                    <xsl:value-of select="$observation/referenceRange/observationRange/value/low/@value"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="high-value"
                      select="normalize-space($observation/referenceRange/observationRange/value/high/@value)"/>

        <xsl:variable name="report-range-low">
            <xsl:if test="not(contains($range,'&amp;lt;'))">
                <xsl:choose>
                    <xsl:when test="$low-value!=''">
                        <xsl:value-of select="$low-value"/>
                    </xsl:when>
                    <xsl:when test="$low-value-from-range!=''">
                        <xsl:value-of select="$low-value-from-range"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$observation/referenceRange/observationRange/text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
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

        <!--Blood bank ABO/RH results are sent in seperate component/observations, but need to be displayed together
            aborh_check takes the result displayname and strips any non-alphanumeric chars out and converts to uppercase
            aborh_check_previous does the same for the previous result
            the if both are ABORH that means we are on the 2nd one so diplay it along with the previous results value
            the $count variable doesn't need to be adjusted with a -1 for the previous result because there is a $organizer/component/procedure
            at the beginning of the entry which needs to be accounted for.  if the $organizer/component/procedure isn't there for other source ccd's
            then this will need to be changed to check for its presence.
        -->
        <xsl:variable name="aborh_check">
            <xsl:value-of select="translate(translate($result,translate($result,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',''),''), $smallcase, $uppercase)"/>
        </xsl:variable>

        <xsl:variable name="aborh_check_previous">
            <xsl:value-of select="translate(translate($organizer/component[$count]/observation/code/@displayName,translate($organizer/component[$count]/observation/code/@displayName,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',''),''), $smallcase, $uppercase)"/>
        </xsl:variable>

        <xsl:variable name="split_aborh">
            <xsl:call-template name="get-split-aborh">
                <xsl:with-param name="source" select="$source-results"/>
            </xsl:call-template>
        </xsl:variable>

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

        <xsl:if test="normalize-space($value)!=''">
            <xsl:if test="($result != '') and (($aborh_check='ABORH' and $aborh_check=$aborh_check_previous and $split_aborh='1') or ($aborh_check!='ABORH' or $split_aborh='0') )">
                <xsl:element name="lab_result">
                    <xsl:element name="SUB_TYPE">
                        lab_result
                    </xsl:element>
                    <xsl:element name="SOURCE">
                        <xsl:value-of select="normalize-space($source-results)"/>
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
                        <xsl:text>lab-results</xsl:text>
                    </xsl:element>
                    <xsl:element name="ORGANIZER_ID">
                        <xsl:value-of select="normalize-space($globalOrganizerId)"/>
                    </xsl:element>
                    <xsl:element name="RESULT_ID">
                        <xsl:value-of select="$result_id"/>
                    </xsl:element>
                    <xsl:element name="RESULT_ID_ALIAS">
                        <xsl:value-of select="concat($order-name,$result)"/>
                    </xsl:element>
                    <xsl:element name="RESULT">
                        <xsl:value-of select="$result"/>
                    </xsl:element>
                    <xsl:element name="RESULT_IBOX_TEXT">
                        <xsl:copy-of select="$report-text"/>
                    </xsl:element>
                    <xsl:element  name="IBOX_CAPTION">
                        <xsl:value-of select="$result-ibox-text-caption"/>
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
                    <xsl:element name="VALUE_UNIT">
                        <xsl:value-of select="$value_unit"/>
                    </xsl:element>
                    <xsl:element name="VALUE_TRANSLATION_UNIT">
                        <xsl:value-of select="$value_translation_unit"/>
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
                    <xsl:element name="RESULT_DATE">
                        <xsl:value-of select="$date-results"/>
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
                    <xsl:element name="ORDER_ALIAS">
                        <xsl:value-of select="$order-alias"/>
                    </xsl:element>
                    <xsl:call-template name="create-comments">
                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                    <xsl:element name="PERFORMER_ID">
                        <xsl:value-of select="normalize-space($updated-id)"/>
                    </xsl:element>
                    <xsl:element name="PERFORMER_ID_OID">
                        <xsl:value-of select="normalize-space($updated-id-oid)"/>
                    </xsl:element>
                    <xsl:element name="PERFORMER_FIRST">
                        <xsl:value-of select="normalize-space($updated-first)"/>
                    </xsl:element>
                    <xsl:element name="PERFORMER_MIDDLE">
                        <xsl:value-of select="normalize-space($updated-middle)"/>
                    </xsl:element>
                    <xsl:element name="PERFORMER_LAST">
                        <xsl:value-of select="normalize-space($updated-last)"/>
                    </xsl:element>
                    <xsl:element name="PERFORMER_SUFFIX">
                        <xsl:value-of select="normalize-space($updated-suffix)"/>
                    </xsl:element>
                    <xsl:element name="ORDERING_PROVIDER_FIRST">
                        <xsl:value-of select="normalize-space($order-provider-firstName)"/>
                    </xsl:element>
                    <xsl:element name="ORDERING_PROVIDER_LAST">
                        <xsl:value-of select="normalize-space($order-provider-lastName)"/>
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

                <xsl:if test="($count=1 and $result != '') or ($procedurePresent!='')">
                    <xsl:element name="lab_result">
                        <xsl:element name="SUB_TYPE">
                            lab_result_order
                        </xsl:element>
                        <xsl:element name="SOURCE">
                            <xsl:value-of select="normalize-space($source-results)"/>
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
                        <xsl:element name="ORGANIZER_ID">
                            <xsl:value-of select="normalize-space($globalOrganizerId)"/>
                        </xsl:element>
                        <xsl:element name="RESULT">
                            <xsl:value-of select="$result"/>
                        </xsl:element>
                        <!--  kn018206 - 11/18/2013 - removing this since it will break de-dup logic for Orders.  Don't need the RESULT_ID for orders anyway
                        <xsl:element name="RESULT_ID">
                            <xsl:value-of select="$result_id"/>
                        </xsl:element> -->
                        <xsl:element name="RESULT_IBOX_TEXT">
                            <xsl:copy-of select="$result-ibox-text"/>
                        </xsl:element>
                        <xsl:element  name="IBOX_CAPTION">
                            <xsl:value-of select="$result-ibox-text-caption"/>
                        </xsl:element>
                        <xsl:element name="RESULT_ID_ALIAS">
                            <xsl:value-of select="concat($order-name,$result)"/>
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
                        <xsl:element name="RESULT_DATE">
                            <xsl:value-of select="$date-results"/>
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
                        <xsl:element name="ORDER_ALIAS">
                            <xsl:value-of select="$order-alias"/>
                        </xsl:element>
                        <xsl:call-template name="create-comments">
                            <xsl:with-param name="contentMap" select="$globalContentMap"/>
                            <xsl:with-param name="node" select="."/>
                        </xsl:call-template>
                        <xsl:element name="PERFORMER_ID">
                            <xsl:value-of select="normalize-space($updated-id)"/>
                        </xsl:element>
                        <xsl:element name="PERFORMER_ID_OID">
                            <xsl:value-of select="normalize-space($updated-id-oid)"/>
                        </xsl:element>
                        <xsl:element name="PERFORMER_FIRST">
                            <xsl:value-of select="normalize-space($updated-first)"/>
                        </xsl:element>
                        <xsl:element name="PERFORMER_MIDDLE">
                            <xsl:value-of select="normalize-space($updated-middle)"/>
                        </xsl:element>
                        <xsl:element name="PERFORMER_LAST">
                            <xsl:value-of select="normalize-space($updated-last)"/>
                        </xsl:element>
                        <xsl:element name="PERFORMER_SUFFIX">
                            <xsl:value-of select="normalize-space($updated-suffix)"/>
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
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-split-aborh">
        <xsl:param name="source"/>

        <xsl:choose>
            <xsl:when test="$source = '2.16.840.1.113883.3.787.31.1'">
                <xsl:text>1</xsl:text>
            </xsl:when>
            <xsl:when test="$source = '2.16.840.1.113883.3.787.32.1'">
                <xsl:text>1</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="get-iboxtext-display">
        <xsl:param name="contentMap"/>
        <xsl:param name="tag-id"/>

        <xsl:variable name="temp-ibox-text" >
            <xsl:copy-of select="util:getmap($contentMap,$tag-id)" />
        </xsl:variable>
        <xsl:variable name="unformatted-ibox-text" >
            <xsl:call-template  name="replace-string" >
                <xsl:with-param name="text" select="$temp-ibox-text" />
                <xsl:with-param name="replace" select="'&lt;paragraph&gt;'"/>
                <xsl:with-param name="by" select="'&lt;p&gt;'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="formatted-ibox-text" >
            <xsl:call-template  name="replace-string" >
                <xsl:with-param name="text" select="$unformatted-ibox-text" />
                <xsl:with-param name="replace" select="'&lt;/paragraph&gt;'"/>
                <xsl:with-param name="by" select="'&lt;/p&gt;'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$formatted-ibox-text" disable-output-escaping="yes" />
    </xsl:template>

    <xsl:template name="get-iboxtext-caption">
        <xsl:param name="contentMap"/>
        <xsl:param name="tag-id"/>
        <xsl:value-of select="util:getmap($contentMap,$tag-id)" />
    </xsl:template>
    <xsl:template name="replace-string">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                                    select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
