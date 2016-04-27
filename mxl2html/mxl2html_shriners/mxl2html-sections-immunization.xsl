<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">

    <xsl:import href="mxl2html-formatting.xsl"/>
    <xsl:import href="mxl2html-lib.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>


    <xsl:template name="build-section-immunization">
        <xsl:param name="section"/>

        <xsl:variable name="table-id">immunizations-table</xsl:variable>
        <xsl:variable name="section-title">IMMUNIZATION / VACCINE HISTORY</xsl:variable>
        <xsl:variable name="summary-div-id">immunizations-summary</xsl:variable>
        <xsl:variable name="details-div-id">immunizations-details</xsl:variable>


        <div class="wrap_window">

            <xsl:call-template name="section-header">
                <xsl:with-param name="title" select="$section-title"/>
                <xsl:with-param name="name" select="$table-id"/>
                <xsl:with-param name="summary-div-id" select="$summary-div-id"/>
                <xsl:with-param name="details-div-id" select="$details-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-immunizations-summary">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$summary-div-id"/>
            </xsl:call-template>

            <xsl:call-template name="section-immunizations-details">
                <xsl:with-param name="section" select="$section"/>
                <xsl:with-param name="div-id" select="$details-div-id"/>
            </xsl:call-template>

        </div>

    </xsl:template>


    <xsl:template name="section-immunizations-summary">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="30">Immunization/Vaccine</col>
                <col width="20">Date Given</col>
                <col width="30">Status</col>
                <col width="20">Source</col>
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

                        <xsl:variable name="immunization">
                            <xsl:value-of select="./IMMUNIZATION"/>
                        </xsl:variable>
                        <xsl:variable name="date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./DATE_GIVEN"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="Route">
                            <xsl:value-of select="./ROUTE"/>
                        </xsl:variable>
                        <xsl:variable name="Site">
                            <xsl:value-of select="./SITE"/>
                        </xsl:variable>
                        <xsl:variable name="Manufacturer">
                            <xsl:value-of select="./MANUFACTURER"/>
                        </xsl:variable>
                        <xsl:variable name="Lot">
                            <xsl:value-of select="./LOT"/>
                        </xsl:variable>
                        <!--This is not the correct locaiton to pull Note.  It will need to be updated at a later date.-->
                        <xsl:variable name="Note">
                            <xsl:value-of select="./NOTE"/>
                        </xsl:variable>

                        <xsl:variable name="status"
                                      select="./STATUS"/>

                        <xsl:variable name="last-updated">
                            <xsl:call-template name="get-lastupdateby-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>

                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$immunization"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <xsl:value-of select="$date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <xsl:value-of select="$status"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$source"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>

                </table>

            </div>

        </div>
    </xsl:template>


    <xsl:template name="section-immunizations-details">
        <xsl:param name="section"/>
        <xsl:param name="div-id"/>

        <xsl:variable name="cols">
            <cols scrolling="true">
                <col width="20">Immunization</col>
                <col width="10">Date Given</col>
                <col width="40">Details</col>
                <col width="10">Status</col>
                <col width="10">Last Updated</col>
                <col width="10">Source</col>
            </cols>
        </xsl:variable>

        <div id="{$div-id}" style="display: none" class="scrollRoot">
            <div class="sectiontableheaderrow">
                <table class="sectiontable scrollHeaderTable" minimal="700">
                    <xsl:attribute name="id"><xsl:value-of select="$div-id"/>-table_header</xsl:attribute>
                    <tr>
                        <xsl:call-template name="create-header-row">
                            <xsl:with-param name="cols" select="$cols"/>
                        </xsl:call-template>
                    </tr>
                </table>
            </div>
            <div class="sectiontablediv scrollHeaderDiv" rowlimit="10">
                <table class="sectiontable sortable" minimal="700">
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

                        <xsl:variable name="immunization">
                            <xsl:value-of select="./IMMUNIZATION"/>
                        </xsl:variable>
                        <xsl:variable name="date">
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="./DATE_GIVEN"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="Route">
                            <xsl:value-of select="./ROUTE"/>
                        </xsl:variable>
                        <xsl:variable name="Site">
                            <xsl:value-of select="./SITE"/>
                        </xsl:variable>
                        <xsl:variable name="Manufacturer">
                            <xsl:value-of select="./MANUFACTURER"/>
                        </xsl:variable>
                        <xsl:variable name="Lot">
                            <xsl:value-of select="./LOT"/>
                        </xsl:variable>
                        <!--This is not the correct locaiton to pull Note.  It will need to be updated at a later date.-->
                        <xsl:variable name="Note">
                            <xsl:value-of select="./NOTE"/>
                        </xsl:variable>

                        <xsl:variable name="status"
                                      select="./STATUS"/>

                        <xsl:variable name="last-updated">
                            <xsl:call-template name="get-lastupdateby-name">
                                <xsl:with-param name="name-tag" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="source">
                            <xsl:call-template name="translate-source">
                                <xsl:with-param name="id-tag" select="./SOURCE"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="value">
                            <xsl:value-of select="./DOSE_QTY"/><xsl:text> </xsl:text><xsl:value-of select="./DOSE_QTY_UNIT"/>
                        </xsl:variable>

                        <xsl:variable name="statusUpCase" select="translate($status, $smallcase, $uppercase)"/>


                        <xsl:if test="$statusUpCase != 'IN ERROR'">
                            <tr>
                                <td width="{$cols/cols/col[position() = 1]/@width}%">
                                    <xsl:value-of select="$immunization"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 2]/@width}%">
                                    <xsl:value-of select="$date"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 3]/@width}%">
                                    <table>
                                        <tbody>
                                            <xsl:if test="$Route != ''">
                                                <tr>
                                                    <td>Route:
                                                        <xsl:value-of select="$Route"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="$Site != ''">
                                                <tr>
                                                    <td>Site:
                                                        <xsl:value-of select="$Site"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="$Manufacturer != ''">
                                                <tr>
                                                    <td>Manufacturer:
                                                        <xsl:value-of select="$Manufacturer"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="$Lot != ''">
                                                <tr>
                                                    <td>Lot #:
                                                        <xsl:value-of select="$Lot"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="$Note != ''">
                                                <tr>
                                                    <td>Note:
                                                        <xsl:value-of select="$Note"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="normalize-space($value) != ''">
                                                <tr>
                                                    <td>Dose:
                                                        <xsl:value-of select="$value"/>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                        </tbody>
                                    </table>
                                </td>
                                <td width="{$cols/cols/col[position() = 4]/@width}%">
                                    <xsl:value-of select="$status"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 5]/@width}%">
                                    <xsl:value-of select="$last-updated"/>
                                </td>
                                <td width="{$cols/cols/col[position() = 6]/@width}%">
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