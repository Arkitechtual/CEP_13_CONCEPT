<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template name="build-section-encounters">
        <xsl:param name="section"/>

        <xsl:variable name="section-title">VISITS</xsl:variable>
        <xsl:variable name="table-id">encounters-table</xsl:variable>
        <xsl:variable name="summary-div-id">encounters-summary</xsl:variable>
        <xsl:variable name="details-div-id">encounters-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-encounters-summary">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-encounters-details">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

        </div>
    </xsl:template>


    <xsl:template name="section-encounters-summary">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Location</col>
                <col width="20">Encounter Type</col>
                <col width="17">Reason For Visit</col>
                <col width="13">Attending Provider</col>
                <col width="10">ADM Date</col>
                <col width="10">DC Date</col>
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

                    <xsl:if test="count($section) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$section">

                        <xsl:variable name="location">
                            <xsl:value-of select="./FACILITY"/>
                        </xsl:variable>
                        <xsl:variable name="encounter-type">
                            <xsl:value-of select="./ENCOUNTER_TYPE"/>
                        </xsl:variable>
                        <xsl:variable name="encounter-number">
                            <xsl:value-of select="./ENCOUNTER_NUMBER"/>
                        </xsl:variable>
                        <xsl:variable name="reason-for-visit">
                            <xsl:value-of select="./REASON"/>
                        </xsl:variable>
                        <xsl:variable name="attending-provider">
                            <xsl:call-template name="get-attending-provider-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="adm-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date"
                                                select="./ADMIT_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="dc-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date"
                                                select="./DISCHARGE_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase = '' or $statusUpCase != 'CANCEL'">

                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$location"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <xsl:value-of select="$encounter-type"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:value-of select="$reason-for-visit"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$attending-provider"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="$adm-date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%">
                                    <xsl:value-of select="$dc-date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 7]/@width}%">
                                    <xsl:value-of select="$source"/>
                                </td>
                            </tr>
                        </xsl:if>

                    </xsl:for-each>

                </table>

            </div>

        </div>
    </xsl:template>

    <xsl:template name="section-encounters-details">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="10">Location</col>
                <col width="10">Location Details</col>
                <col width="10">Encounter Type</col>
                <col width="10">Encounter Number</col>
                <col width="10">Reason For Visit</col>
                <col width="10">Attending Provider</col>
                <col width="10">ADM Date</col>
                <col width="10">DC Date</col>
                <col width="10">Status</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="900">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">

                <table class="sectiontable sortable" minimal="900">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table</xsl:attribute>

                    <tr class="sectiontable-printheaderrow">
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>

                    <xsl:if test="count($section) = 0">
                        <tr><td class="empty-table"><xsl:attribute name="colspan"><xsl:value-of select="count($cols/cols/col)"/></xsl:attribute>No records found</td></tr>
                    </xsl:if>

                    <xsl:for-each select="$section">

                        <xsl:variable name="location">
                            <xsl:value-of select="./FACILITY"/>
                        </xsl:variable>
                        <xsl:variable name="encounter-type">
                            <xsl:value-of select="./ENCOUNTER_TYPE"/>
                        </xsl:variable>
                        <xsl:variable name="encounter-number">
                            <xsl:value-of select="./ENCOUNTER_NUMBER"/>
                        </xsl:variable>
                        <xsl:variable name="reason-for-visit">
                            <xsl:value-of select="./REASON"/>
                        </xsl:variable>
                        <xsl:variable name="attending-provider">
                            <xsl:call-template name="get-attending-provider-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template> 
                        </xsl:variable>
                        <xsl:variable name="adm-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date"
                                                select="./ADMIT_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="dc-date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date"
                                                select="./DISCHARGE_DATE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="status">
                            <xsl:value-of select="./STATUS"/>
                        </xsl:variable>
                        <xsl:variable name="location-details">
                            <xsl:value-of select="./BUILDING"/>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>
                        <xsl:if test="$statusUpCase = '' or $statusUpCase != 'CANCEL'">

                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$location"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <xsl:value-of select="$location-details"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:value-of select="$encounter-type"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$encounter-number"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="$reason-for-visit"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%">
                                    <xsl:value-of select="$attending-provider"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 7]/@width}%">
                                    <xsl:value-of select="$adm-date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 8]/@width}%">
                                    <xsl:value-of select="$dc-date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 9]/@width}%">
                                    <xsl:value-of select="$status"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 10]/@width}%">
                                    <xsl:value-of select="$source"/>
                                </td>
                            </tr>
                        </xsl:if>

                    </xsl:for-each>

                </table>

            </div>

        </div><div> </div>
    </xsl:template>

</xsl:stylesheet>