<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <xsl:template name="build-section-micro">
        <xsl:param name="organizer"/>

        <xsl:variable name="section-title">MICROBIOLOGY</xsl:variable>
        <xsl:variable name="table-id">micro-table</xsl:variable>
        <xsl:variable name="summary-div-id">micro-summary</xsl:variable>
        <xsl:variable name="details-div-id">micro-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-micro-summary">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-micro-details">
                <xsl:with-param name="organizer" select="$organizer"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>
            
        </div>
    </xsl:template>


    <xsl:template name="section-micro-summary">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Result</col>
                <col width="30">Observation</col>
                <col width="15">Result Date</col>
                <col width="10">Resulted By</col>
                <col width="15">Source</col>
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

                     <xsl:if test="count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_Micro']) = 0">
						<tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$organizer">

                        <xsl:variable name="order">
                            <xsl:choose>
                                <xsl:when test="./RESULT !=''">
                                    <xsl:value-of select="./RESULT"/>
                                </xsl:when>
                                <xsl:when test="./ORDER_NAME !=''">
                                    <xsl:value-of select="./ORDER_NAME"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="provider">
                            <xsl:call-template name="get-ordering-provider-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="formated-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./RESULT_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="comment">
                            <xsl:value-of select="./COMMENTS"/>
                        </xsl:variable>
                        <xsl:variable name="last-updated">
                            <xsl:value-of select="./LAST_UPDATED_BY"/>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-identifier"
                                      select="./RESULT_ID"/>
                        <xsl:variable name="sub-data-type"
                                      select="./SUB_DATA_TYPE"/>
                        <xsl:variable name="value">
                            <xsl:value-of select="./VALUE"/>
                            <xsl:if test="./VALUE_UNIT != ''">
                                <xsl:text> </xsl:text><xsl:value-of select="./VALUE_UNIT"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="verified-by">
                            <xsl:call-template name="get-verifier-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />

                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>
                                <!--<td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <a href="javascript:void(0);">
                                        <xsl:attribute name="id">name_title_<xsl:value-of
                                                select="normalize-space($report-identifier)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                select='normalize-space($report-identifier)'/>');
                                        </xsl:attribute>
                                        <xsl:value-of select="normalize-space($order)"/>
                                    </a>
                                </td>            -->
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$order"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <xsl:variable name="value-display">
                                        <xsl:call-template name="removeHtmlTags">
                                            <xsl:with-param name="html" select="$value"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <a href="javascript:void(0);">
                                        <xsl:attribute name="id">name_title_<xsl:value-of
                                                select="normalize-space($report-identifier)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                select='normalize-space($report-identifier)'/>');
                                        </xsl:attribute>
                                        <xsl:value-of select="concat(substring($value-display,0,20),'...')"/>
                                    </a>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:if test="$formated-date!=''"><xsl:value-of
                                            select="$formated-date"/>
                                    </xsl:if>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$verified-by"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="$source"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                     <xsl:for-each select="./document/Other_Document">

                         <xsl:if test="normalize-space(substring-before(./name,'-'))='_Micro'">

                             <tr>
                                 <td width="{$cols/cols/col[position() = 1]/@width}%">
                                     <xsl:value-of select="substring-after(./name,'-')"/>
                                 </td>
                                 <td width="{$cols/cols/col[position() = 2]/@width}%">
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
                                 <td width="{$cols/cols/col[position() = 3]/@width}%">
                                     <xsl:call-template name="format-date">
                                         <xsl:with-param name="date" select="./date"/>
                                     </xsl:call-template>
                                 </td>
                                 <td width="{$cols/cols/col[position() = 4]/@width}%">
                                     <xsl:value-of select="./author"/>
                                 </td>
                                 <td width="{$cols/cols/col[position() = 5]/@width}%">
                                     <xsl:value-of select="./source"/>
                                 </td>
                             </tr>
                         </xsl:if>
                     </xsl:for-each>
                </table>
            </div>

        </div>
    </xsl:template>


    <xsl:template name="section-micro-details">
        <xsl:param name="organizer"/>
        <xsl:param name="div-id"/>
        
        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Result</col>
                <col width="20">Observation</col>
                <col width="20">Result Date</col>
                <col width="10">Comments</col>
                <col width="15">Resulted By</col>
                <col width="15">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="800">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">

                <table class="sectiontable sortable" minimal="800">

                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($organizer) = 0 and count(./document/Other_Document/name[normalize-space(substring-before(text(),'-'))='_Micro']) = 0">
						<tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
					</xsl:if>  

                    <xsl:for-each select="$organizer">

                        <xsl:variable name="order">
                            <xsl:choose>
                                <xsl:when test="./RESULT !=''">
                                    <xsl:value-of select="./RESULT"/>
                                </xsl:when>
                                <xsl:when test="./ORDER_NAME !=''">
                                    <xsl:value-of select="./ORDER_NAME"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="provider">
                            <xsl:call-template name="get-ordering-provider-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="formated-date">
                            <xsl:choose>
                                <xsl:when test="./RESULT_DATE !=''">
                                <xsl:call-template name="format-date">
                                    <xsl:with-param name="date" select="./RESULT_DATE"/>
                                </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="./RESULT_DATE !=''">
                                <xsl:call-template name="format-date">
                                    <xsl:with-param name="date" select="./RESULT_DATE"/>
                                </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="comment">
                            <xsl:value-of select="normalize-space(/COMMENTS)"/>
                        </xsl:variable>
                        <xsl:variable name="last-updated">
                            <xsl:value-of select="./LAST_UPDATED_BY"/>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="report-identifier"
                                      select="./RESULT_ID"/>
                        <xsl:variable name="sub-data-type"
                                      select="./SUB_DATA_TYPE"/>
                        <xsl:variable name="value">
                            <xsl:value-of select="./VALUE"/>
                            <xsl:if test="./VALUE_UNIT != ''">
                                <xsl:text> </xsl:text><xsl:value-of select="./VALUE_UNIT"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="verified-by">
                            <xsl:call-template name="get-verifier-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)" />

                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$order"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <!--<xsl:variable name="value-display1"><xsl:value-of select="substring(replace($value,'&lt;br/&gt;',''),0,20)"/></xsl:variable>-->
                                    <xsl:variable name="value-display">
                                        <xsl:call-template name="removeHtmlTags">
                                            <xsl:with-param name="html" select="$value"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <a href="javascript:void(0);">
                                        <xsl:attribute name="id">name_title_<xsl:value-of
                                                select="normalize-space($report-identifier)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="onclick">OpenWindow('<xsl:value-of
                                                select='normalize-space($report-identifier)'/>');
                                        </xsl:attribute>
                                        <xsl:value-of select="concat(substring($value-display,0,20),'...')"/>
                                        <!--<xsl:choose>
                                            <xsl:when test="string-length(substring-before($value-display,'&lt;')) &gt; 0 and string-length(substring-before($value-display,'&lt;')) &lt; 20">
                                                <xsl:value-of select="concat(substring($value-display,0,string-length(substring-before($value-display,'&lt;')) + 1),'...')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($value-display,'...')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                     -->
                                        <!--<xsl:value-of select="concat(substring(replace($value,'&lt;br/&gt;',''),0,20),'...')"/>-->
                                    </a>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:if test="$formated-date!=''"><xsl:value-of
                                            select="$formated-date"/>
                                    </xsl:if>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$comment"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="$verified-by"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%">
                                    <xsl:value-of select="$source"/>
                                </td>
                            </tr>
                        </xsl:if> 
                    </xsl:for-each>
                    <xsl:for-each select="./document/Other_Document">

                        <xsl:if test="normalize-space(substring-before(./name,'-'))='_Micro'">

                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="substring-after(./name,'-')"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
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
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:call-template name="format-date">
                                        <xsl:with-param name="date" select="./date"/>
                                    </xsl:call-template>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="./author"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%">
                                    <xsl:value-of select="./source"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </table>
            </div>

        </div><div> </div>
        
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
                        <xsl:variable name="mrn" select="normalize-space(/document/patient/patientIds[1]/patientId/mrn)"/>

                        <xsl:variable name="patient-name">
                            <xsl:value-of select="/document/patient/firstName"/><xsl:text> </xsl:text><xsl:value-of select="/document/patient/middleName"/>
                            <xsl:text> </xsl:text><xsl:value-of select="/document/patient/lastName"/>
                            <xsl:if test="/document/patient/suffix != ''">
                                <xsl:text>, </xsl:text><xsl:value-of select="/document/patient/suffix"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="specimen_source" select="normalize-space(./SPECIMEN_SOURCE)"/>
                        <xsl:variable name="specimen_site" select="normalize-space(./SPECIMEN_SITE)"/>

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
                                            <td>Specimen date:</td>
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
                                        <xsl:if test="$report-title != ''">
                                            <tr>
                                                <td>Result title:</td>
                                                <td><xsl:value-of select="$report-title"/></td>
                                            </tr>
                                        </xsl:if>
                                        <tr>
                                            <td>Performed by:</td>
                                            <td><xsl:value-of select="normalize-space($performer-name)"/> on
                                                <xsl:value-of select="$perform-date"/>&#160;<xsl:value-of select="$perform-time"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Verified by:</td>
                                            <td><xsl:value-of select="normalize-space($verifier-name)"/> on
                                                <xsl:value-of select="$verify-date"/>&#160;<xsl:value-of select="$verify-time"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Encounter info:</td>
                                            <td><xsl:value-of select="$encounter_num"/>, <xsl:value-of
                                                    select="$enc_location"/>,
                                                <xsl:value-of select="$patient-type"/>
                                            </td>
                                        </tr>

                                        <xsl:if test="$specimen_source != '' or $specimen_site != ''">
                                            <tr>
                                                <td>Specimen Source:</td>
                                                <td><xsl:value-of select="normalize-space($specimen_source)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Specimen Site:</td>
                                                <td><xsl:value-of select="normalize-space($specimen_site)"/>
                                                </td>
                                            </tr>
                                        </xsl:if>

                                    </table>
                                    <table>
                                        <tr>
                                            <td><br/><xsl:copy-of select="$report-text-rtf/node()"/></td>
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
                                                <td><xsl:copy-of select="$report-note/node()"/></td>
                                            </tr>
                                        </xsl:if>
                                    </table>
                                    <table>
                                        <xsl:if test="count(./SUSCEPTIBLITIES/susceptibility) > 0">
                                            <xsl:for-each-group select="./SUSCEPTIBLITIES/susceptibility" group-by="ORGANISM">
                                                <xsl:for-each-group select="current-group()" group-by="TEST_METHOD">
                                                    <tr>
                                                        <td><br/></td>
                                                    </tr>
                                                    <tr>
                                                        <td><b><xsl:value-of select="./ORGANISM"/></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td><xsl:value-of select="./TEST_DIL_HEADER"/></td>
                                                        <td><xsl:value-of select="./TEST_INTERP_HEADER"/></td>
                                                    </tr>
                                                    <xsl:for-each select="current-group()">
                                                        <tr>
                                                            <td><xsl:value-of select="./ANTIBIOTIC_NAME"/></td>
                                                            <td><xsl:value-of select="./ANTIBIOTIC_RESULT"/></td>
                                                            <td><xsl:value-of select="./ANTIBIOTIC_INTERP"/></td>
                                                            <td><xsl:value-of select="./ANTIBIOTIC_NOTE"/></td>
                                                        </tr>
                                                    </xsl:for-each>
                                                </xsl:for-each-group>
                                            </xsl:for-each-group>
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

    <xsl:template name="removeHtmlTags">
    <xsl:param name="html"/>
        <xsl:choose>
          <xsl:when test="contains($html, '&lt;b&gt;')">
            <xsl:call-template name="removeHtmlTags">
              <xsl:with-param name="html" select="replace($html, '&lt;b&gt;','')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="contains($html, '&lt;/b&gt;')">
            <xsl:call-template name="removeHtmlTags">
              <xsl:with-param name="html" select="replace($html, '&lt;/b&gt;','')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="contains($html, '&lt;br/&gt;')">
            <xsl:call-template name="removeHtmlTags">
              <xsl:with-param name="html" select="replace($html, '&lt;br/&gt;','')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$html"/>
          </xsl:otherwise>
        </xsl:choose>
        <!--
        <xsl:choose>
          <xsl:when test="contains($html, '&lt;')">
            <xsl:value-of select="substring-before($html, '&lt;')"/>
            <xsl:call-template name="removeHtmlTags">
              <xsl:with-param name="html" select="substring-after($html, '&gt;')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$html"/>
          </xsl:otherwise>
        </xsl:choose>                  -->
  </xsl:template>

</xsl:stylesheet>