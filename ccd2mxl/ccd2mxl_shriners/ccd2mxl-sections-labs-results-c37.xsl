<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">

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

        <!-- details all -->
        <xsl:for-each select="entryRelationship/organizer">

            <xsl:variable name="current-organizer" select="."/>

                <xsl:for-each select="./component/observation">  <!-- loop thru each result of all orders -->

                    <xsl:call-template name="make-observations-row-c37">
                        <xsl:with-param name="observation" select="."/>
                        <xsl:with-param name="organizer" select="$current-organizer"/>
                        <xsl:with-param name="count" select="position()"/>
                    </xsl:call-template>

                </xsl:for-each>

        </xsl:for-each>
    </xsl:template>


    <xsl:template name="make-observations-row-c37">
        <xsl:param name="observation"/>
        <xsl:param name="organizer"/>
        <xsl:param name="count"/>

        <!--
Order_code = organizer/code@code
Order_name = organizer/code@displayName
Order_code_source = organizer/code@codeSystem
Result/name = organizer/component/observation/code@displayName
RESULTS_CODE = organizer/component/observation/code@code
RESULTS_CODE_SOURCE = organizer/component/observation/code@codeSystemName

        -->

        <xsl:variable name="order-name">
            <xsl:choose>
                <xsl:when test="$organizer/code/originalText != ''">
                    <xsl:value-of select="$organizer/code/originalText" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$organizer/code/@displayName" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="order-code" select="$organizer/code/@code"/>
        <xsl:variable name="order-code-source" select="$organizer/code/@codeSystem"/>
        <xsl:variable name="order-alias" select="$organizer/id/originalText"/>

        <xsl:variable name="result_disp">
            <xsl:if test="$observation/text/reference/@value !='' and $observation/text/reference/@value !='UNK'">
                <xsl:call-template name="get-content-display" >
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id" select="translate($observation/text/reference/@value,'#','')" />
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="result">
            <xsl:choose>
                <xsl:when test="$observation/code/@displayName !=''">
                    <xsl:value-of select="$observation/code/@displayName" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$result_disp" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="result-code" select="$observation/code/@code"/>
        <xsl:variable name="result-code-source" select="$observation/code/@codeSystem"/>
        <xsl:variable name="result_id">
            <xsl:choose>
                <xsl:when test="$observation/text/reference/@value !=''">
                    <xsl:value-of select="$observation/text/reference/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$result-code" /><xsl:value-of select="$result" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="status" select="$observation/statusCode/@code"/>

        <xsl:variable name="reference_value">
            <xsl:if test="$observation/value/originalText/reference/@value != ''">
                <xsl:call-template name="get-content-display" >
                    <xsl:with-param name="contentMap" select="$globalContentMap"/>
                        <xsl:with-param name="tag-id" select="translate($observation/value/originalText/reference/@value,'#','')" />
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="value_data_type" select="$observation/value/@xsi:type"/>
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="$value_data_type = 'CD'">
                    <xsl:choose>
                        <xsl:when test="normalize-space($reference_value) != ''">
                            <xsl:value-of select="normalize-space($reference_value)" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$observation/value/@displayName" />
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
                        <xsl:when test="$observation/value/@value">
                            <xsl:value-of select="$observation/value/@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$observation/value/originalText/reference/@value != ''">
                                    <xsl:call-template name="get-content-display" >
                                        <xsl:with-param name="contentMap" select="$globalContentMap"/>
                                            <xsl:with-param name="tag-id" select="translate($observation/value/originalText/reference/@value,'#','')" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$observation/value" />
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
                <xsl:value-of select="$observation/value/@unit" />
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="interpretationCode">
            <xsl:choose>
                <xsl:when test="$observation/interpretationCode/@code != '' and $observation/interpretationCode/@code = 'OTH'">
                    <xsl:value-of select="translate($observation/interpretationCode/@displayName,' ','')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$observation/interpretationCode/@code" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="interpretation">
            <xsl:value-of select="$observation/interpretationCode/@displayName"/>
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
                <xsl:with-param name="author-tag" select="$organizer/author" />
            </xsl:call-template>
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

        <xsl:variable name="range" select="normalize-space(./referenceRange/observationRange)"/>
        <xsl:variable name="low-value-from-range" select="normalize-space(tokenize($range,'-')[1])"/>
        <xsl:variable name="high-value-from-range" select="normalize-space(tokenize($range,'-')[2])"/>
        <xsl:variable name="low-value"
                      select="normalize-space($observation/referenceRange/observationRange/value/low/@value)"/>
        <xsl:variable name="high-value"
                      select="normalize-space($observation/referenceRange/observationRange/value/high/@value)"/>


        <xsl:variable name="report-range-low">
            <xsl:choose>
                <xsl:when test="$low-value">
                    <xsl:value-of select="$low-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$low-value-from-range"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="report-range-high">
            <xsl:choose>
                <xsl:when test="$high-value">
                    <xsl:value-of select="$high-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$high-value-from-range"/>
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
                <xsl:otherwise>
                    <xsl:value-of select="$globalEncounterId"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="($result != '') and (($aborh_check='ABORH' and $aborh_check=$aborh_check_previous and $split_aborh='1') or ($aborh_check!='ABORH' or $split_aborh='0') )">
            <xsl:element name="Result">
                <xsl:element name="MXL_TYPE">
                    labs_result
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
                <xsl:element name="RESULT_ID">
                    <xsl:value-of select="$result_id"/>
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
                    <xsl:choose>
                        <xsl:when test="$aborh_check='ABORH' and $split_aborh='1'">
                            <xsl:value-of select="$value"/><xsl:text>, </xsl:text><xsl:value-of select="$organizer/component[$count]/observation/value" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$value"/>
                        </xsl:otherwise>
                    </xsl:choose>
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
                <xsl:element name="PERFORMER">
                    <xsl:element name="ID">
                        <xsl:value-of select="normalize-space($updated-id)"/>
                    </xsl:element>
                    <xsl:element name="ID_OID">
                        <xsl:value-of select="normalize-space($updated-id-oid)"/>
                    </xsl:element>
                    <xsl:element name="FIRST">
                        <xsl:value-of select="normalize-space($updated-first)"/>
                    </xsl:element>
                    <xsl:element name="MIDDLE">
                        <xsl:value-of select="normalize-space($updated-middle)"/>
                    </xsl:element>
                    <xsl:element name="LAST">
                        <xsl:value-of select="normalize-space($updated-last)"/>
                    </xsl:element>
                    <xsl:element name="SUFFIX">
                        <xsl:value-of select="normalize-space($updated-suffix)"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="VERIFIER">
                    <xsl:element name="ID">
                        <xsl:value-of select="normalize-space($verifier-id)"/>
                    </xsl:element>
                    <xsl:element name="ID_OID">
                        <xsl:value-of select="normalize-space($verifier-id-oid)"/>
                    </xsl:element>
                    <xsl:element name="FIRST">
                        <xsl:value-of select="normalize-space($verifier-first)"/>
                    </xsl:element>
                    <xsl:element name="MIDDLE">
                        <xsl:value-of select="normalize-space($verifier-middle)"/>
                    </xsl:element>
                    <xsl:element name="LAST">
                        <xsl:value-of select="normalize-space($verifier-last)"/>
                    </xsl:element>
                    <xsl:element name="SUFFIX">
                        <xsl:value-of select="normalize-space($verifier-suffix)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>

        <xsl:if test="$count=1 and $result != ''">
            <xsl:element name="Result-order">
                <xsl:element name="MXL_TYPE">
                    labs_result
                </xsl:element>
                <xsl:element name="SOURCE">
                    <xsl:value-of select="normalize-space($source-results)"/>
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
                <xsl:element name="PERFORMER">
                    <xsl:element name="ID">
                        <xsl:value-of select="normalize-space($updated-id)"/>
                    </xsl:element>
                    <xsl:element name="ID_OID">
                        <xsl:value-of select="normalize-space($updated-id-oid)"/>
                    </xsl:element>
                    <xsl:element name="FIRST">
                        <xsl:value-of select="normalize-space($updated-first)"/>
                    </xsl:element>
                    <xsl:element name="MIDDLE">
                        <xsl:value-of select="normalize-space($updated-middle)"/>
                    </xsl:element>
                    <xsl:element name="LAST">
                        <xsl:value-of select="normalize-space($updated-last)"/>
                    </xsl:element>
                    <xsl:element name="SUFFIX">
                        <xsl:value-of select="normalize-space($updated-suffix)"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="VERIFIER">
                    <xsl:element name="ID">
                        <xsl:value-of select="normalize-space($verifier-id)"/>
                    </xsl:element>
                    <xsl:element name="ID_OID">
                        <xsl:value-of select="normalize-space($verifier-id-oid)"/>
                    </xsl:element>
                    <xsl:element name="FIRST">
                        <xsl:value-of select="normalize-space($verifier-first)"/>
                    </xsl:element>
                    <xsl:element name="MIDDLE">
                        <xsl:value-of select="normalize-space($verifier-middle)"/>
                    </xsl:element>
                    <xsl:element name="LAST">
                        <xsl:value-of select="normalize-space($verifier-last)"/>
                    </xsl:element>
                    <xsl:element name="SUFFIX">
                        <xsl:value-of select="normalize-space($verifier-suffix)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
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
</xsl:stylesheet>