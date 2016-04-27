<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3"
                xmlns:rtf="http://www.browsersoft.com/">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template name="get-report-text">
        <xsl:param name="data_type"/>
        <xsl:param name="text_value"/>
        <!--<xsl:choose>   rtf is handled in the rule file now.
            <xsl:when test="$data_type ='ED'">
                <xsl:value-of select="rtf:rtftohtml(normalize-space($text_value))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate($text_value,' ','&#160;')"/>
            </xsl:otherwise>
        </xsl:choose> -->
        <!--<xsl:value-of select="translate($text_value,' ','&#160;')"/>-->

        <xsl:copy-of select="$text_value/node()"/>

    </xsl:template>

    <xsl:template name="build-section-results">

        <xsl:param name="organizer"/>
        <xsl:param name="organizer-type"/>

        <xsl:variable name="table-id"><xsl:value-of select="$organizer-type"/>-result-table</xsl:variable>
        <xsl:variable name="section-title">
            <xsl:choose>
                <xsl:when test="normalize-space($organizer-type) = 'microbiology'">Microbiology</xsl:when>
                <xsl:when test="normalize-space($organizer-type) = 'anatomic-pathology'">Anatomic Pathology</xsl:when>
                <xsl:when test="normalize-space($organizer-type) = 'radiology'">Radiology</xsl:when>
                <xsl:when test="normalize-space($organizer-type) = 'history-physical'">History &amp; Physical</xsl:when>
                <xsl:when test="normalize-space($organizer-type) = 'discharge-summary'">Discharge Summary</xsl:when>
                <xsl:when test="normalize-space($organizer-type) = 'other-reports'">Provider Reports</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="summary-div-id"><xsl:value-of select="$organizer-type"/>-summary</xsl:variable>
        <xsl:variable name="details-div-id"><xsl:value-of select="$organizer-type"/>-details</xsl:variable>

        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="results-summary">
                <xsl:with-param name="div-id" select="$summary-div-id"/>
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="organizer-type" select="$organizer-type"/>
            </xsl:call-template>

            <xsl:call-template name="results-details">
                <xsl:with-param name="div-id" select="$details-div-id"/>
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="organizer-type" select="$organizer-type"/>
            </xsl:call-template>

        </div>

    </xsl:template>

    <xsl:template name="results-summary">
        <xsl:param name="div-id"/>
        <xsl:param name="organizer"/>
        <xsl:param name="organizer-type"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                    <col width="20">Report Type</col>
                    <col width="20">Report Name</col>
                    <col width="20">Performed by</col>
                    <col width="20">Date Completed</col>
                    <col width="10">Status</col>
                    <col width="10">Source</col>
                </xsl:if>
                <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                    <col width="20">Report Name</col>
                    <col width="20">Performed by</col>
                    <col width="20">Date Completed</col>
                    <col width="20">Status</col>
                    <col width="20">Source</col>
                </xsl:if>

            </cols>
        </xsl:variable>

        <div id="{$div-id}" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">

                <table class="sectiontable sortable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                    <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                        <xsl:if test="count($organizer) = 0 and count(./document/Other_Document) = 0">
                            <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'radiology' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_Radiology']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'discharge-summary' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_DischSum']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'history-physical' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_HistAndPhysical']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'anatomic-pathology' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_AP']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$organizer">  <!-- roll through orders -->
                        <xsl:sort select="./RESULT_DATE" order="descending"/>
                        <xsl:sort select="./RESULT"/>

                        <xsl:variable name="report-name" select="./RESULT"/>
                        <xsl:variable name="performer-name">
                            <xsl:call-template name="get-performer-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-identifier"
                                      select="./RESULT_ID"/>
                        <xsl:variable name="report_date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./RESULT_DATE"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="format-time">
                                <xsl:with-param name="date" select="./RESULT_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-status" select="./STATUS"/>
                        <xsl:variable name="report-title" select="./EVENT_TITLE"/>
                        <xsl:variable name="data_type" select="./VALUE_DATA_TYPE"/>
                        <xsl:variable name="result_value" select="./VALUE"/>
                        <xsl:variable name="url">
                            <xsl:if test="$data_type = 'RP'">

                                    <xsl:text>http://localhost:3003/?</xsl:text>
                                <xsl:text>url=</xsl:text><xsl:value-of select="substring-before($result_value,'^')" />
                                <xsl:text>&amp;doc_id=</xsl:text><xsl:value-of select="substring-after($result_value,'^')" />
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($report-status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>

                                <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a href="javascript:void(0);">
                                            <xsl:attribute name="id">name_title_<xsl:value-of
                                                    select="normalize-space($report-identifier)"/>
                                            </xsl:attribute>
                                            <xsl:if test="$url != ''">
                                                <xsl:attribute name="onclick">OpenWindowUrl('<xsl:value-of
                                                        select='normalize-space($url)'/>');
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="$url = ''">
                                                <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                        select='normalize-space($report-identifier)'/>');
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="normalize-space($report-name)"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="normalize-space($report-title)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="normalize-space($performer-name)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:value-of select="normalize-space($report_date)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        <xsl:value-of select="normalize-space($report-status)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                                        <xsl:value-of select="normalize-space($source)"/>
                                    </td>
                                    <!--<td></td>-->
                                </xsl:if>

                                <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a href="javascript:void(0);">
                                            <xsl:attribute name="id">name_title_<xsl:value-of
                                                    select="normalize-space($report-identifier)"/>
                                            </xsl:attribute>
                                            <xsl:if test="$url != ''">
                                                <xsl:attribute name="onclick">OpenWindowUrl('<xsl:value-of
                                                        select='normalize-space($url)'/>');
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="$url = ''">
                                                <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                        select='normalize-space($report-identifier)'/>');
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="normalize-space($report-name)"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="normalize-space($performer-name)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="normalize-space($report_date)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:value-of select="normalize-space($report-status)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        <xsl:value-of select="normalize-space($source)"/>
                                    </td>
                                </xsl:if>


                            </tr>
                        </xsl:if>


                    </xsl:for-each>       <!--
                    <xsl:if test="normalize-space($organizer-type) = 'other-reports'">

                        <xsl:for-each select="./document/Other_Document">
                            <tr>
                                <td>
                                    <a>
                                        <xsl:if test="./documentType = 'div'">
                                            <xsl:attribute name="href">
                                                <xsl:text disable-output-escaping="yes">javascript:OpenWindow2('</xsl:text>
                                                <xsl:value-of select="id"/>
                                                <xsl:text disable-output-escaping="yes">')</xsl:text>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="./documentType = 'document'">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="value"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">
                                                _blank
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="./type"/>
                                        <xsl:if test="./type = 'MIG_Document'">
                                            <xsl:text disable-output-escaping="yes"> - </xsl:text>
                                            <xsl:value-of select="./name"/>
                                        </xsl:if>
                                    </a>
                                </td>
                                <td>
                                    <xsl:value-of select="./name"/>
                                </td>
                                <td>
                                    <xsl:value-of select="./author"/>
                                </td>
                                <td>
                                   <xsl:call-template name="format-date">
                                        <xsl:with-param name="date" select="./date"/>
                                   </xsl:call-template>
                                </td>
                                <td>
                                    completed
                                </td>
                                <td>
                                    <xsl:value-of select="./source"/>
                                </td>

                                <div style="display: none">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="./value"/>
                                </div>
                            </tr>
                        </xsl:for-each>
                    </xsl:if>                   -->
                    <xsl:for-each select="./document/Other_Document">

                        <xsl:if test="(normalize-space($organizer-type) = 'other-reports' and (normalize-space(substring-before(./name,'-'))='_Provider' or ./type = 'MIG_Document')) or
                           (normalize-space($organizer-type) = 'radiology' and normalize-space(substring-before(./name,'-'))='_Radiology') or
                           (normalize-space($organizer-type) = 'history-physical' and normalize-space(substring-before(./name,'-'))='_HistAndPhysical')  or
                           (normalize-space($organizer-type) = 'discharge-summary' and normalize-space(substring-before(./name,'-'))='_DischSum')  or
                           (normalize-space($organizer-type) = 'anatomic-pathology' and normalize-space(substring-before(./name,'-'))='_AP')">

                            <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                                <tr>
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a>
                                            <xsl:if test="./documentType = 'div'">
                                                <xsl:attribute name="href">
                                                    <xsl:text disable-output-escaping="yes">javascript:OpenWindow2('</xsl:text>
                                                    <xsl:value-of select="id"/>
                                                    <xsl:text disable-output-escaping="yes">')</xsl:text>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="./documentType = 'document'">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    _blank
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="./type"/>
                                            <xsl:text disable-output-escaping="yes"> - </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="./type = 'MIG_Document'">
                                                    <xsl:value-of select="./name"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="substring-after(./name,'-')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="./author"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:call-template name="format-date">
                                            <xsl:with-param name="date" select="./date"/>
                                        </xsl:call-template>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        completed
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        <xsl:value-of select="./source"/>
                                    </td>
                                    <div style="display: none">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="id"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="./value"/>
                                    </div>
                                </tr>
                            </xsl:if>
                            <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                                <tr>
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a>
                                            <xsl:if test="./documentType = 'div'">
                                                <xsl:attribute name="href">
                                                    <xsl:text disable-output-escaping="yes">javascript:OpenWindow2('</xsl:text>
                                                    <xsl:value-of select="id"/>
                                                    <xsl:text disable-output-escaping="yes">')</xsl:text>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="./documentType = 'document'">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    _blank
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="./type"/>
                                            <xsl:text disable-output-escaping="yes"> - </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="./type = 'MIG_Document'">
                                                    <xsl:value-of select="./name"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="substring-after(./name,'-')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:choose>
                                            <xsl:when test="./type = 'MIG_Document'">
                                                <xsl:value-of select="./name"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-after(./name,'-')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="./author"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:call-template name="format-date">
                                            <xsl:with-param name="date" select="./date"/>
                                        </xsl:call-template>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        completed
                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                                        <xsl:value-of select="./source"/>
                                    </td>
                                    <div style="display: none">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="id"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="./value"/>
                                    </div>
                                </tr>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </table>

            </div>


        </div>


        <table class="display-none">
            <tr class="display-none">
                <td class="display-none">
                    <xsl:for-each select="$organizer">
                        <xsl:variable name="report-text-rtf">
                            <xsl:call-template name="get-report-text">
                                <xsl:with-param name="data_type" select="./VALUE_DATA_TYPE"/>
                                <xsl:with-param name="text_value" select="./VALUE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-title" select="normalize-space(./EVENT_TITLE)"/>
                        <xsl:variable name="report-identifier" select="normalize-space(./RESULT_ID)"/>
                        <xsl:variable name="report-status" select="normalize-space(./STATUS)"/>
                        <xsl:variable name="report-name" select="normalize-space(./RESULT)"/>
                        <xsl:variable name="encounter_num" select="normalize-space(./ENCOUNTER_NUM)"/>
                        <xsl:variable name="enc_location" select="normalize-space(./ENCOUNTER_LOCATION)"/>
                        <xsl:variable name="report_date" select="normalize-space(./RESULT_DATE)"/>
                        <xsl:variable name="performer-name">
                            <xsl:call-template name="get-performer-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="verifier-name">
                            <xsl:call-template name="get-verifier-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="perform-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="normalize-space(./PERFORM_DATE)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="perform-time">
                            <xsl:call-template name="format-time">
                                <xsl:with-param name="date" select="normalize-space(./PERFORM_DATE)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="verify-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="normalize-space(./VERIFY_DATE)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="verify-time">
                            <xsl:call-template name="format-time">
                                <xsl:with-param name="date" select="normalize-space(./VERIFY_DATE)"/>
                            </xsl:call-template>
                        </xsl:variable>


                        <xsl:variable name="report-note" select="./COMMENTS"/>

                        <xsl:variable name="patient-type" select="normalize-space(./PATIENT_TYPE)"/>
                        <xsl:variable name="mrn" select="normalize-space('')"/>

                        <xsl:variable name="patient-name">
                            <xsl:call-template name="get-name">
                                <xsl:with-param name="name"
                                                select="/root/hl7:ClinicalDocument[1]/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($report-status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase != 'IN ERROR'">

                            <div class="yui-dt-hidden">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$report-identifier"/>
                                </xsl:attribute>
                                <div>
                                <table>
                                    <tr>
                                        <td><xsl:value-of select="$report-name"/></td>
                                        <td><xsl:value-of select="$patient-name"/> - <xsl:value-of select="$mrn"/></td>
                                    </tr>
                                    <tr>
                                        <td>Result type:</td>
                                        <td><xsl:value-of select="$report-name"/></td>
                                    </tr>
                                    <tr>
                                        <td>Result date:</td>
                                        <td>
                                            <xsl:call-template name="format-date">
                                                <xsl:with-param name="date" select="$report_date"/>
                                            </xsl:call-template>
                                            <xsl:text> </xsl:text>
                                            <xsl:call-template name="format-time">
                                                <xsl:with-param name="date" select="$report_date"/>
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Result status:</td>
                                        <td><xsl:value-of select="$report-status"/></td>
                                    </tr>
                                    <tr>
                                        <td>Result title:</td>
                                        <td><xsl:value-of select="$report-title"/></td>
                                    </tr>
                                    <tr>
                                        <td>Performed by:</td>
                                        <td><xsl:value-of select="normalize-space($performer-name)"/> on
                                            <xsl:value-of select="$perform-date"/><xsl:text> </xsl:text><xsl:value-of select="$perform-time"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Verified by:</td>
                                        <td><xsl:value-of select="normalize-space($verifier-name)"/> on
                                            <xsl:value-of select="$verify-date"/><xsl:text> </xsl:text><xsl:value-of select="$verify-time"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Encounter info:</td>
                                        <td><xsl:value-of select="$encounter_num"/>, <xsl:value-of
                                                select="$enc_location"/>,
                                            <xsl:value-of select="$patient-type"/>
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td><br/>___UNESCAPE-START___<xsl:copy-of select="$report-text-rtf/node()"/>___UNESCAPE-END___</td>
                                        <td></td>
                                    </tr>
                                </table>
                                <table>

                                    <xsl:if test="normalize-space($report-note) != ''">
                                        <tr>
                                            <td><br/>Signature Line </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>___UNESCAPE-START___<xsl:copy-of select="$report-note/node()"/>___UNESCAPE-END___</td>
                                        </tr>
                                    </xsl:if>
                                </table>
                                </div>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </table>


    </xsl:template>


    <xsl:template name="results-details">
        <xsl:param name="div-id"/>
        <xsl:param name="organizer"/>
        <xsl:param name="organizer-type"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                    <col width="20">Report Type</col>
                    <col width="16">Report Name</col>
                    <col width="13">Performed by</col>
                    <col width="15">Date Completed</col>
                    <col width="14">Status</col>
                    <col width="12">Last Updated</col>
                    <col width="10">Source</col>
                </xsl:if>
                <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                    <col width="20">Report Name</col>
                    <col width="20">Performed by</col>
                    <col width="16">Date Completed</col>
                    <col width="14">Status</col>
                    <col width="20">Last Updated</col>
                    <col width="10">Source</col>
                </xsl:if>

            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                        <xsl:if test="count($organizer) = 0 and count(./document/Other_Document) = 0">
                            <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'radiology' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_Radiology']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'discharge-summary' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_DischSum']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'history-physical' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_HistAndPhysical']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:if test="normalize-space($organizer-type) = 'anatomic-pathology' and
                        count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_AP']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$organizer">  <!-- roll through orders -->
                        <xsl:sort select="./RESULT_DATE" order="descending"/>
                        <xsl:sort select="./RESULT"/>

                        <xsl:variable name="report-name" select="./RESULT"/>
                        <xsl:variable name="performer-name">
                            <xsl:call-template name="get-performer-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>  
                        </xsl:variable>
                        <xsl:variable name="report-identifier"
                                      select="./RESULT_ID"/>
                        <xsl:variable name="report_date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./RESULT_DATE"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="format-time">
                                <xsl:with-param name="date" select="./RESULT_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-status" select="./STATUS"/>
                        <xsl:variable name="report-title" select="./EVENT_TITLE"/>

                        <xsl:variable name="statusUpCase" select="translate($report-status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>

                                <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <xsl:value-of select="normalize-space($report-name)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <a href="javascript:void(0);">
                                            <xsl:attribute name="id">name_title_<xsl:value-of
                                                    select="normalize-space($report-identifier)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                    select='normalize-space($report-identifier)'/>');
                                            </xsl:attribute>
                                            <xsl:value-of select="normalize-space($report-title)"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="normalize-space($performer-name)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:value-of select="normalize-space($report_date)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        <xsl:value-of select="normalize-space($report-status)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%"></td>
                                    <td width="{$cols/cols/col[position() = 7]/@width}%">
                                        <xsl:value-of select="normalize-space($source)"/>
                                    </td>
                                    <!--<td></td>-->
                                </xsl:if>

                                <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a href="javascript:void(0);">
                                            <xsl:attribute name="id">name_title_<xsl:value-of
                                                    select="normalize-space($report-identifier)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                    select='normalize-space($report-identifier)'/>');
                                            </xsl:attribute>
                                            <xsl:value-of select="normalize-space($report-name)"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="normalize-space($performer-name)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="normalize-space($report_date)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:value-of select="normalize-space($report-status)"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                                        <xsl:value-of select="normalize-space($source)"/>
                                    </td>
                                </xsl:if>
                            </tr>
                        </xsl:if>


                    </xsl:for-each>
                    <xsl:for-each select="./document/Other_Document">

                        <xsl:if test="(normalize-space($organizer-type) = 'other-reports' and normalize-space(substring-before(./name,'-'))='_Provider') or
                           (normalize-space($organizer-type) = 'radiology' and normalize-space(substring-before(./name,'-'))='_Radiology') or
                           (normalize-space($organizer-type) = 'history-physical' and normalize-space(substring-before(./name,'-'))='_HistAndPhysical')  or
                           (normalize-space($organizer-type) = 'discharge-summary' and normalize-space(substring-before(./name,'-'))='_DischSum')  or
                           (normalize-space($organizer-type) = 'anatomic-pathology' and normalize-space(substring-before(./name,'-'))='_AP') ">

                            <xsl:if test="normalize-space($organizer-type) != 'other-reports'">
                                <tr>
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a>
                                            <xsl:if test="./documentType = 'div'">
                                                <xsl:attribute name="href">
                                                    <xsl:text disable-output-escaping="yes">javascript:OpenWindow2('</xsl:text>
                                                    <xsl:value-of select="id"/>
                                                    <xsl:text disable-output-escaping="yes">')</xsl:text>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="./documentType = 'document'">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    _blank
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="./type"/>
                                            <xsl:text disable-output-escaping="yes"> - </xsl:text>
                                            <xsl:value-of select="substring-after(./name,'-')"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="./author"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:call-template name="format-date">
                                            <xsl:with-param name="date" select="./date"/>
                                        </xsl:call-template>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        completed
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">

                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%">
                                        <xsl:value-of select="./source"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="normalize-space($organizer-type) = 'other-reports'">
                                <tr>
                                    <td width="{$cols/cols/col[position() = 1]/@width}%">
                                        <a>
                                            <xsl:if test="./documentType = 'div'">
                                                <xsl:attribute name="href">
                                                    <xsl:text disable-output-escaping="yes">javascript:OpenWindow2('</xsl:text>
                                                    <xsl:value-of select="id"/>
                                                    <xsl:text disable-output-escaping="yes">')</xsl:text>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="./documentType = 'document'">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    _blank
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="./type"/>
                                        </a>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 2]/@width}%">
                                        <xsl:value-of select="substring-after(./name,'-')"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 3]/@width}%">
                                        <xsl:value-of select="./author"/>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 4]/@width}%">
                                        <xsl:call-template name="format-date">
                                            <xsl:with-param name="date" select="./date"/>
                                        </xsl:call-template>
                                    </td>
                                    <td width="{$cols/cols/col[position() = 5]/@width}%">
                                        completed
                                    </td>
                                    <td width="{$cols/cols/col[position() = 6]/@width}%">

                                    </td>
                                    <td width="{$cols/cols/col[position() = 7]/@width}%">
                                        <xsl:value-of select="./source"/>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </table>


            </div>

        </div><div> </div>

    </xsl:template>

</xsl:stylesheet>