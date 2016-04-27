<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template name="build-section-medications">
        <xsl:param name="section"/>

        <xsl:variable name="table-id">medications-table</xsl:variable>
        <xsl:variable name="section-title">MEDICATIONS (RX and documented Historical/Home Medications)</xsl:variable>
        <xsl:variable name="summary-div-id">medications-summary</xsl:variable>
        <xsl:variable name="details-div-id">medications-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-medications-summary">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-medications-details">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

        </div>

    </xsl:template>


    <xsl:template name="section-medications-summary">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Medication name</col>
                <col width="25">Details</col>
                <col width="20">Status</col>
                <col width="20">Order Date</col>
                <col width="10">Source</col>
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

                    <xsl:if test="count($section[STATUS_CODE='55561003']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:for-each select="$section">
                        <xsl:call-template name="make-medication-row-summary">
                            <xsl:with-param name="medication" select="."/>
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </table>

            </div>

        </div>
    </xsl:template>


    <xsl:template name="section-medications-details">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Medication name</col>
                <col width="15">Details</col>
                <col width="10">Status</col>
                <col width="10">Patient Instructions</col>
                <col width="10">Ordering Provider</col>
                <col width="10">Order Date</col>
                <col width="10">Last Reviewed By</col>
                <col width="10">Source</col>
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

                    <xsl:if test="count($section[STATUS_CODE='55561003']) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>
                    <xsl:for-each select="$section">
                        <xsl:call-template name="make-medication-row-details">
                            <xsl:with-param name="medication" select="."/>
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </table>

            </div>

        </div><div> </div>
    </xsl:template>

    <xsl:template name="make-medication-row-summary">
        <xsl:param name="medication"/>
        <xsl:param name="cols"/>

        <xsl:variable name="name">
            <xsl:value-of
                    select="$medication/MEDICATION"/>
        </xsl:variable>

                <xsl:variable name="details">
                    <xsl:choose>
                        <xsl:when test="$medication/DETAIL_LINE != ''">
                            <xsl:value-of select="$medication/DETAIL_LINE"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="($medication/DOSE_QTY != '') and ($medication/DOSE_QTY_UNIT != '')">
                                    <xsl:if test="$medication/DOSE_QTY != ''">
                                        <xsl:value-of select="$medication/DOSE_QTY"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$medication/DOSE_QTY_UNIT"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="($medication/DOSE_QTY != '')">
                                    <xsl:value-of select="$medication/DOSE_QTY"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$medication/DOSE_QTY_UNIT"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$medication/RATE_QTY_UNIT != ''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$medication/RATE_QTY_UNIT"/>
                            </xsl:if>

                            <xsl:if test="$medication/PRN_IND != '' and $medication/PRN_IND != '0'">
                                <xsl:text>, PRN</xsl:text>
                            </xsl:if>
                            <xsl:if test="$medication/ROUTE_DISPLAY != ''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$medication/ROUTE_DISPLAY"/>
                            </xsl:if>
                            <xsl:if test="$medication/DISPENSE != ''">
                                <xsl:text>, Dispense: </xsl:text>
                                <xsl:value-of
                                        select="$medication/DISPENSE"/>
                            </xsl:if>
                            <xsl:if test="$medication/REFILLS != ''">
                                <xsl:text>, Refills: </xsl:text>
                                <xsl:value-of
                                        select="$medication/REFILLS"/>
                            </xsl:if>
                            <xsl:if test="$medication/PRN_TEXT !=''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of
                                        select="$medication/PRN_TEXT"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

        <xsl:variable name="status">
            <xsl:choose>
                <xsl:when test="$medication/STATUS != '55561003'">
                    <xsl:value-of select="$medication/STATUS"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Active</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="status_cd">
            <xsl:value-of select="$medication/STATUS_CODE"/>
        </xsl:variable>

        <xsl:variable name="formated-date">
            <xsl:if test="$medication/ORDER_DATE">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="date"
                                    select="$medication/ORDER_DATE"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="source">
            <xsl:call-template name="translate-source">
                <xsl:with-param name="id-tag" select="$medication/SOURCE"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

        <xsl:if test="$statusUpCase = 'ACTIVE' or $statusUpCase = 'DOCUMENTED' or $statusUpCase = 'ORDERED' or $status_cd='55561003'">
            <tr class="row-summary">
                <td width="{$cols/cols/col[position() = 1]/@width}%">
                    <xsl:value-of select="$name"/>
                </td>
                <td width="{$cols/cols/col[position() = 2]/@width}%">
                    <xsl:value-of select="$details"/>
                </td>
                <td width="{$cols/cols/col[position() = 3]/@width}%">
                    <xsl:value-of select="$status"/>
                </td>
                <td width="{$cols/cols/col[position() = 4]/@width}%">
                    <xsl:if test="$formated-date!=''">
                        <xsl:value-of select="$formated-date"/>
                    </xsl:if>
                </td>
                <td width="{$cols/cols/col[position() = 5]/@width}%">
                    <xsl:value-of select="$source"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="make-medication-row-details">
        <xsl:param name="medication"/>
        <xsl:param name="cols"/>

        <xsl:variable name="name">
                    <xsl:value-of
                            select="$medication/MEDICATION"/>
                </xsl:variable>

                <xsl:variable name="details">
                    <xsl:choose>
                        <xsl:when test="$medication/DETAIL_LINE != ''">
                            <xsl:value-of select="$medication/DETAIL_LINE"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="($medication/DOSE_QTY != '') and ($medication/DOSE_QTY_UNIT != '')">
                                    <xsl:if test="$medication/DOSE_QTY != ''">
                                        <xsl:value-of select="$medication/DOSE_QTY"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$medication/DOSE_QTY_UNIT"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="($medication/DOSE_QTY != '')">
                                    <xsl:value-of select="$medication/DOSE_QTY"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$medication/DOSE_QTY_UNIT"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$medication/RATE_QTY_UNIT != ''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$medication/RATE_QTY_UNIT"/>
                            </xsl:if>

                            <xsl:if test="$medication/PRN_IND != '' and $medication/PRN_IND != '0'">
                                <xsl:text>, PRN</xsl:text>
                            </xsl:if>
                            <xsl:if test="$medication/ROUTE_DISPLAY != ''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$medication/ROUTE_DISPLAY"/>
                            </xsl:if>
                            <xsl:if test="$medication/DISPENSE != ''">
                                <xsl:text>, Dispense: </xsl:text>
                                <xsl:value-of
                                        select="$medication/DISPENSE"/>
                            </xsl:if>
                            <xsl:if test="$medication/REFILLS != ''">
                                <xsl:text>, Refills: </xsl:text>
                                <xsl:value-of
                                        select="$medication/REFILLS"/>
                            </xsl:if>
                            <xsl:if test="$medication/PRN_TEXT !=''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of
                                        select="$medication/PRN_TEXT"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="status">
                    <xsl:choose>
                        <xsl:when test="$medication/STATUS != '55561003'">
                            <xsl:value-of select="$medication/STATUS"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Active</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="status_cd">
                    <xsl:value-of select="$medication/STATUS_CODE"/>
                </xsl:variable>

                <xsl:variable name="formated-date">
                    <xsl:if test="$medication/ORDER_DATE">
                        <xsl:call-template name="format-date">
                            <xsl:with-param name="date"
                                            select="$medication/ORDER_DATE"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="source">
                    <xsl:call-template name="translate-source">
                        <xsl:with-param name="id-tag" select="$medication/SOURCE"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

        <xsl:variable name="ordering-provider">
            <xsl:call-template name="get-ordering-provider-name">
                <xsl:with-param name="name-tag" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="patient-instructions">
            <xsl:value-of select="$medication/INSTRUCTIONS"/>
        </xsl:variable>
        <xsl:variable name="updated">
            <xsl:call-template name="get-lastrewiewedby-name">
                <xsl:with-param name="name-tag" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$statusUpCase = 'ACTIVE' or $statusUpCase = 'DOCUMENTED' or $statusUpCase = 'ORDERED' or $status_cd='55561003'">
            <tr class="row-summary">
                <td width="{$cols/cols/col[position() = 1]/@width}%">
                    <xsl:value-of select="$name"/>
                </td>
                <td width="{$cols/cols/col[position() = 2]/@width}%">
                    <xsl:value-of select="$details"/>
                </td>
                <td width="{$cols/cols/col[position() = 3]/@width}%">
                    <xsl:value-of select="$status"/>
                </td>
                <td width="{$cols/cols/col[position() = 4]/@width}%">
                    <xsl:value-of select="$patient-instructions"/>
                </td>
                <td width="{$cols/cols/col[position() = 5]/@width}%">
                    <xsl:value-of select="$ordering-provider"/>
                </td>
                <td width="{$cols/cols/col[position() = 6]/@width}%">
                    <xsl:if test="$formated-date!=''">
                        <xsl:value-of select="$formated-date"/>
                    </xsl:if>
                </td>
                <td width="{$cols/cols/col[position() = 7]/@width}%">
                    <xsl:value-of select="$updated"/>
                </td>
                <td width="{$cols/cols/col[position() = 8]/@width}%">
                    <xsl:value-of select="$source"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>